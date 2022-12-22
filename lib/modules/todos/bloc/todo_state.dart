part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState(this.todos);

  final List<Todo> todos;

  @override
  List<Object> get props => [...todos];
}

class TodoInitial extends TodoState {
  const TodoInitial() : super(const []);
}

class TodoLoading extends TodoState {
  const TodoLoading(super.todos);
}

class TodoLoaded extends TodoState {
  const TodoLoaded(super.todos);
}
