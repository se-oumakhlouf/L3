/// @file
#ifndef JOBLIST_H
#define JOBLIST_H

#include <stdbool.h>
#include <stdlib.h>

/// Dynamic array (a.k.a. vector) of strings.
/// The implementation ensures that the array is always `NULL`-terminated.
typedef struct {
  char **array;    ///< The actual array.
  size_t size;     ///< Current number of strings.
  size_t capacity; ///< Maximum number of strings before reallocation.
} StrVec;

/// Representation of a process.
typedef struct Proc {
  struct Proc *next; ///< Link to the next process.
  StrVec *args;      ///< Argument vector.
  char *redin;       ///< Input redirection file name.
  char *redout;      ///< Output redirection file name.
  bool append;       ///< Whether output should be appended (if redirected).
  pid_t pid;         ///< Process identifier.
} Proc;

/// Singly linked list of processes.
typedef struct {
  Proc *head; ///< First process.
  Proc *tail; ///< Last process.
} ProcList;

/// Representation of a job.
typedef struct Job {
  struct Job *prev;   ///< Link to the previous job.
  struct Job *next;   ///< Link to the next job.
  char *cmdLine;      ///< Original command line.
  ProcList *pipeline; ///< Sequence of processes constituting the job.
  bool bg;            ///< Whether the job should be started in the background.
  int id;             ///< Job identifier.
} Job;

/// Doubly linked list of jobs.
typedef struct {
  Job *head; ///< First job.
} JobList;

/// -----
/// @name StrVec

/// Constructs an empty vector of strings.
StrVec *newStrVec(void);

/// Destroys a string vector with all its contents.
void delStrVec(StrVec *vec);

/// Prints a textual representation of a string vector.
void printStrVec(const StrVec *vec);

/// Appends string `str` to the end of vector `vec`.
/// `vec` takes ownership of `str`, so `str` should not be freed afterwards.
void addStrToVec(char *str, StrVec *vec);

/// -----
/// @name Proc

/// Constructs an empty process.
Proc *newProc(void);

/// Destroys a process and all its resources.
void delProc(Proc *proc);

/// Prints a textual representation of a process.
void printProc(const Proc *proc);

/// -----
/// @name ProcList

/// Constructs an empty list of processes.
ProcList *newProcList(void);

/// Destroys a process list with all its contents.
void delProcList(ProcList *list);

/// Prints a textual representation of a process list.
void printProcList(const ProcList *list);

/// Appends process `proc` to the end of `list`.
/// `list` takes ownership of `proc`, so `proc` should not be freed afterwards.
void addProcToListTail(Proc *proc, ProcList *list);

/// Returns the process identified by `pid` if `list` contains such a process,
/// and otherwise `NULL`. The process is not removed from `list`.
Proc *getProcByPidFromList(pid_t pid, ProcList *list);

/// -----
/// @name Job

/// Constructs an empty job.
Job *newJob(void);

/// Constructs a job representing the command line `cmdLine`.
/// Returns either the new job or `NULL` in case of a syntax error. The new job
/// takes ownership of `cmdLine`, so `cmdLine` should not be freed afterwards
/// (not even if `NULL` was returned).
Job *newJobFromCmdLine(char *cmdLine);

/// Destroys a job and all its resources.
void delJob(Job *job);

/// Prints a textual representation of a job.
void printJob(const Job *job);

/// -----
/// @name JobList

/// Constructs an empty list of jobs.
JobList *newJobList(void);

/// Destroys a job list with all its contents.
void delJobList(JobList *list);

/// Prints a textual representation of a job list.
void printJobList(const JobList *list);

/// Inserts `job` at the beginning of `list` and assigns a unique ID to `job->id`.
/// `list` takes ownership of `job`, so `job` should not be freed afterwards.
void addJobToListHead(Job *job, JobList *list);

/// Removes `job` from `list` (which must necessarily contain `job`).
/// `list` gives up ownership of `proc`, so `proc` can be freed afterwards.
void remJobFromList(Job *job, JobList *list);

/// Moves `job` to the beginning of `list` (which must already contain `job`).
void moveJobToListHead(Job *job, JobList *list);

/// Returns the job with identifier `id` if `list` contains such a job,
/// and otherwise `NULL`. The job is not removed from `list`.
Job *getJobByIdFromList(int id, JobList *list);

/// Returns the process identified by `pid` if `list` contains a job with such
/// a process, and otherwise `NULL`. The process is not removed from its job.
Proc *getProcByPidFromJobList(pid_t pid, JobList *list);

#endif // JOBLIST_H
