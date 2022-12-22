class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  final int id;
  final String title;
  final String description;
  final bool isDone;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  @override
  String toString() {
    return 'Todo { id: $id, title: $title, description: $description, isDone: $isDone }';
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
