import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { TodoListComponent } from './app/todo-list/todo-list.component';

@NgModule({
  imports: [BrowserModule, FormsModule],
  declarations: [AppComponent, TodoListComponent],
  bootstrap: [AppComponent],
})
export class AppModule {}
