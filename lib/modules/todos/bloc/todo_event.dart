part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodo extends TodoEvent {
  const AddTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  const UpdateTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  const DeleteTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}
