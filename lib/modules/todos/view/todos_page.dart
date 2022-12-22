import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/modules/todos/bloc/todo_bloc.dart';

class TodoChangeCubit extends Cubit<Todo> {
  TodoChangeCubit(super.todo);

  void set(Todo todo) => emit(todo);
}

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  void _onAddTodo(BuildContext context) {
    final todoChangeCubit = context.read<TodoChangeCubit>();
    final todoBloc = context.read<TodoBloc>();

    showDialog(
      context: context,
      builder: (_) {
        return BlocBuilder<TodoChangeCubit, Todo>(
          bloc: todoChangeCubit,
          builder: (_, state) {
            final todoChangeCubit = context.read<TodoChangeCubit>();

            return AlertDialog(
              title: const Text('Add todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      todoChangeCubit.set(state.copyWith(title: value));
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      todoChangeCubit.set(state.copyWith(description: value));
                    },
                    onSubmitted: (value) {
                      todoBloc.add(AddTodo(todoChangeCubit.state));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    todoBloc.add(AddTodo(todoChangeCubit.state));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(),
        ),
        BlocProvider(
          create: (context) => TodoChangeCubit(
              Todo(id: DateTime.now().millisecond, title: '', description: '')),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: const _TodosContentWidget(),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () => _onAddTodo(context),
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

class _TodosContentWidget extends StatelessWidget {
  const _TodosContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoInitial) {
          return const Center(
            child: Text('No todos'),
          );
        } else if (state is TodoLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TodoLoaded) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text('No todos'),
            );
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];

              return ListTile(
                title: Text(
                  todo.title,
                  style: todo.isDone
                      ? const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        )
                      : null,
                ),
                subtitle: todo.isDone
                    ? null
                    : Text(
                        todo.description,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<TodoBloc>().add(DeleteTodo(todo));
                  },
                ),
                onTap: () {
                  context
                      .read<TodoBloc>()
                      .add(UpdateTodo(todo.copyWith(isDone: !todo.isDone)));
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}
