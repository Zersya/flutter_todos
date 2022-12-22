import 'package:equatable/equatable.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial()) {
    on<AddTodo>(_addTodo);
    on<UpdateTodo>(_updateTodo);
    on<DeleteTodo>(_deleteTodo);
  }

  Future<void> _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));

    await Future<void>.delayed(const Duration(milliseconds: 150));
    emit(TodoLoaded([...state.todos, event.todo]));
  }

  Future<void> _updateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));

    // await Future<void>.delayed(const Duration(milliseconds: 250));
    emit(TodoLoaded([
      for (final todo in state.todos)
        if (todo.id == event.todo.id) event.todo else todo
    ]));
  }

  Future<void> _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));

    await Future<void>.delayed(const Duration(milliseconds: 150));
    emit(TodoLoaded([
      for (final todo in state.todos)
        if (todo.id != event.todo.id) todo
    ]));
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoLoaded([
      for (final todo in json['todos'] as List<dynamic>)
        Todo.fromMap(todo as Map<String, dynamic>)
    ]);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return {
      'todos': state.todos.map((todo) => todo.toMap()).toList(),
    };
  }
}
