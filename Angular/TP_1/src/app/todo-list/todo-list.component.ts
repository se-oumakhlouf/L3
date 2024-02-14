import { Component, OnInit } from '@angular/core';
import { Todo } from '../model/todo';

@Component({
  selector: 'app-todo-list',
  templateUrl: './todo-list.component.html',
  styleUrls: ['./todo-list.component.css'],
})
export class TodoListComponent implements OnInit {
  constructor() {}

  ngOnInit() {}

  newTaskLabel: string;

  public todos: Todo[] = [
    { label: 'Angular', done: true },
    { label: 'BDD', done: false },
    { label: 'Avan_C', done: true },
  ];

  toggleDone(task: Todo): void {
    task.done = !task.done;
  }

  addTask(): void {
    this.todos.push({ label: this.newTaskLabel, done: false });
    this.newTaskLabel = '';
  }
}
