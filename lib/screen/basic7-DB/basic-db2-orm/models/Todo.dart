class Todo {
  final int? id;
  final String title;
  final bool isDone;
  final String priority;  // high / medium / low
  final String createdAt; // ISO 8601 문자열 → 커서 기준으로 사용

  Todo({
    this.id,
    required this.title,
    this.isDone = false,
    this.priority = 'medium',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'isDone': isDone ? 1 : 0,
    'priority': priority,
    'createdAt': createdAt,
  };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    id: map['id'] as int?,
    title: map['title'] as String,
    isDone: (map['isDone'] as int) == 1,
    priority: map['priority'] as String,
    createdAt: map['createdAt'] as String,
  );

  Todo copyWith({
    int? id, String? title, bool? isDone,
    String? priority, String? createdAt,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
      );
}