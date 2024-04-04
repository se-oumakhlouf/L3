#include <assert.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "joblist.h"
#include "parser.h"
#include "try.h"

Job *parsedJob;

// -----
// Utilities

// Stack of bits encoded as a 64-bit integer.
typedef uint64_t BitStack;
#define SIZEMASK ((BitStack) 0x3F) // lowest 6 bits encode stack size
#define BOTTOMBIT ((BitStack) 1 << 63)
#define EMPTYSTACK ((BitStack) 0)
//   bottom                           top
//  ┌────────────────────────────────────┬─────────────────────┬──────┐
//  │            stack content          ←╎→   zeroed memory    │ size │
//  └────────────────────────────────────┴─────────────────────┴──────┘
//  ├──────────────────────────────────────────────────────────┼──────┤
//                               58                                6

static BitStack push(BitStack stack, bool bit) {
  int oldSize = stack & SIZEMASK;
  BitStack newTop = bit ? (BOTTOMBIT >> oldSize) : 0;
  return (stack | newTop) + 1;
}

// A variant of `printf()` that adds a prefix of box-drawing symbols to the
// output in order to include it as a node in a textual tree representation.
// The prefix is provided as a bit stack that tells us for each ancestor of the
// node whether the ancestor has any successor sibling.
static void treePrintf(BitStack prefix, const char *format, ...) {
  int prefixSize = prefix & SIZEMASK;
  BitStack position = BOTTOMBIT;
  for (int i = 0 ; i < prefixSize - 1; i++) {
    printf("%s", prefix & position ? u8"│   " : u8"    ");
    position >>= 1;
  }
  if (prefixSize > 0) {
    printf("%s", prefix & position ? u8"├── " : u8"└── ");
  }
  va_list args;
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
}

static const char *boolStr(bool bit) {
  return bit ? "true" : "false";
}

static void printStr(const char *str, const char *end) {
  if (str) {
    printf("\"%s\"%s", str, end);
  }
  else {
    printf("NULL%s", end);
  }
}

// -----
// StrVec

StrVec *newStrVec(void) {
  StrVec *result = try(malloc(sizeof(StrVec)), NULL);
  result->array = try(malloc(sizeof(char *)), NULL);
  result->array[0] = NULL;
  result->size = 0;
  result->capacity = 0;
  return result;
}

void delStrVec(StrVec *vec) {
  for (char **sp = vec->array; *sp; sp++) {
    free(*sp);
  }
  free(vec->array);
  free(vec);
}

void printStrVec(const StrVec *vec) {
  printf("[");
  char* sep = "";
  for (size_t i = 0; i <= vec->size; i++, sep = ", ") {
    printf("%s", sep);
    printStr(vec->array[i], "");
  }
  printf("]\n");
}

void addStrToVec(char *str, StrVec *vec) {
  if (vec->size == vec->capacity) {
    vec->capacity = 2 * vec->capacity + (vec->capacity ? 0 : 1);
    vec->array = try(realloc(vec->array,
                             (vec->capacity + 1) * sizeof(char *)),
                     NULL);
  }
  vec->array[vec->size++] = str;
  vec->array[vec->size] = NULL;
}

// -----
// Proc

Proc *newProc(void) {
  Proc *result = try(malloc(sizeof(Proc)), NULL);
  result->next = NULL;
  result->args = NULL;
  result->redin = NULL;
  result->redout = NULL;
  result->append = false;
  result->pid = -1;
  return result;
}

void delProc(Proc *proc) {
  delStrVec(proc->args);
  free(proc->redin);
  free(proc->redout);
  free(proc);
}

static void treePrintProc(BitStack prefix, const Proc *proc) {
  BitStack pfxCont = push(prefix, true);
  BitStack pfxLast = push(prefix, false);
  treePrintf(pfxCont, "args->array: ");
  printStrVec(proc->args);
  treePrintf(pfxCont, "redin: ");
  printStr(proc->redin, "\n");
  treePrintf(pfxCont, "redout: ");
  printStr(proc->redout, "\n");
  treePrintf(pfxCont, "append: %s\n", boolStr(proc->append));
  treePrintf(pfxLast, "pid: %ld\n", (long) proc->pid);
}

void printProc(const Proc *proc) {
  printf("<Proc>\n");
  treePrintProc(EMPTYSTACK, proc);
}

// -----
// ProcList

ProcList *newProcList(void) {
  ProcList *result = try(malloc(sizeof(ProcList)), NULL);
  result->head = NULL;
  result->tail = NULL;
  return result;
}

void delProcList(ProcList *list) {
  Proc *curr = list->head;
  while (curr) {
    Proc *prev = curr;
    curr = curr->next;
    delProc(prev);
  }
  free(list);
}

static void treePrintProcList(BitStack prefix, const ProcList *list) {
  int i = 1;
  for (Proc *proc = list->head; proc; proc = proc->next) {
    BitStack pfxNext = push(prefix, proc->next);
    treePrintf(pfxNext, "<Proc> %d\n", i++);
    treePrintProc(pfxNext, proc);
  }
}

void printProcList(const ProcList *list) {
  printf("<ProcList>\n");
  treePrintProcList(EMPTYSTACK, list);
}

void addProcToListTail(Proc *proc, ProcList *list) {
  if (!list->head) {
    list->head = proc;
  }
  if (list->tail) {
    list->tail->next = proc;
  }
  list->tail = proc;
}

Proc *getProcByPidFromList(pid_t pid, ProcList *list) {
  for (Proc *proc = list->head; proc; proc = proc->next) {
    if (proc->pid == pid) {
      return proc;
    }
  }
  return NULL;
}

// -----
// Job

Job *newJob(void) {
  Job *result = try(malloc(sizeof(Job)), NULL);
  result->prev = NULL;
  result->next = NULL;
  result->cmdLine = NULL;
  result->pipeline = NULL;
  result->bg = false;
  result->id = -1;
  return result;
}

void yylex_destroy(void);
typedef struct yy_buffer_state *YY_BUFFER_STATE;
YY_BUFFER_STATE yy_scan_string(const char *str);
void yy_delete_buffer(YY_BUFFER_STATE buffer);

Job *newJobFromCmdLine(char *cmdLine) {
  static bool calledAtExit = false;
  if (!calledAtExit) {
    atexit(yylex_destroy);
    calledAtExit = true;
  }
  parsedJob = NULL;
  YY_BUFFER_STATE buffer = yy_scan_string(cmdLine);
  yyparse(); // updates `parsedJob`
  yy_delete_buffer(buffer);
  if (parsedJob) {
    parsedJob->cmdLine = cmdLine;
  }
  else {
    free(cmdLine);
  }
  return parsedJob;
}

void delJob(Job *job) {
  free(job->cmdLine);
  delProcList(job->pipeline);
  free(job);
}

static void treePrintJob(BitStack prefix, const Job *job) {
  BitStack pfxCont = push(prefix, true);
  BitStack pfxLast = push(prefix, false);
  treePrintf(pfxCont, "cmdLine: ");
  printStr(job->cmdLine, "\n");
  treePrintf(pfxCont, "pipeline\n");
  treePrintProcList(pfxCont, job->pipeline);
  treePrintf(pfxCont, "bg: %s\n", boolStr(job->bg));
  treePrintf(pfxLast, "id: %d\n", job->id);
}

void printJob(const Job *job) {
  printf("<Job>\n");
  treePrintJob(EMPTYSTACK, job);
}

// -----
// JobList

JobList *newJobList(void) {
  JobList *result = try(malloc(sizeof(JobList)), NULL);
  result->head = NULL;
  return result;
}

void delJobList(JobList *list) {
  Job *curr = list->head;
  while (curr) {
    Job *prev = curr;
    curr = curr->next;
    delJob(prev);
  }
  free(list);
}

static void treePrintJobList(BitStack prefix, const JobList *list) {
  for (Job *job = list->head; job; job = job->next) {
    BitStack pfxNext = push(prefix, job->next);
    treePrintf(pfxNext, "<Job> %d\n", job->id);
    treePrintJob(pfxNext, job);
  }
}

void printJobList(const JobList *list) {
  printf("<JobList>\n");
  treePrintJobList(EMPTYSTACK, list);
}

static int getFreeJobId(const JobList *list) {
  int max = 0;
  for (Job *job = list->head; job; job = job->next) {
    if (job->id > max) {
      max = job->id;
    }
  }
  return max + 1;
}

static void prependJobToList(Job *job, JobList *list) {
  job->prev = NULL;
  job->next = list->head;
  if (list->head) {
    list->head->prev = job;
  }
  list->head = job;
}

void addJobToListHead(Job *job, JobList *list) {
  assert(job != NULL);
  job->id = getFreeJobId(list);
  prependJobToList(job, list);
}

void remJobFromList(Job *job, JobList *list) {
  assert(job != NULL);
  if (job->prev) {
    job->prev->next = job->next;
  }
  else {
    list->head = job->next;
  }
  if (job->next) {
    job->next->prev = job->prev;
  }
  job->prev = NULL;
  job->next = NULL;
}

void moveJobToListHead(Job *job, JobList *list) {
  remJobFromList(job, list);
  prependJobToList(job, list);
}

Job *getJobByIdFromList(int id, JobList *list) {
  for (Job *job = list->head; job; job = job->next) {
    if (job->id == id) {
      return job;
    }
  }
  return NULL;
}

Proc *getProcByPidFromJobList(pid_t pid, JobList *list) {
  for (Job *job = list->head; job; job = job->next) {
    Proc *proc = getProcByPidFromList(pid, job->pipeline);
    if (proc) {
      return proc;
    }
  }
  return NULL;
}
