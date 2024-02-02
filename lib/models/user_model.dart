import 'package:todo_app/models/task_model.dart';

class UserModel {
  String uid;
  String name;
  String? imageUrl;
  List<Task> tasks;

  UserModel({
    required this.uid,
    required this.name,
    required this.tasks,
    this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    List<Task> tasks = [];

    if (map.containsKey('tasks')) {
      map['tasks'].forEach((taskMap) {
        tasks.add(Task.fromMap(taskMap));
      });
    }

    return UserModel(
      uid: map['uid'],
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tasks: tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tasks': tasks.map((task) => task.toMap()),
    };
  }
}
