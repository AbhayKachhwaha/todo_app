class Task {
  String description;
  bool isCompleted;

  Task({required this.description, this.isCompleted = false});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'],
      isCompleted: map['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
