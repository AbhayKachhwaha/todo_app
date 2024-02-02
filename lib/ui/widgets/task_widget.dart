import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firestore_database.dart';

import '../../models/task_model.dart';
import 'edit_task_widget.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});
  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void _handleChecked(bool? isCompleted) {
    setState(() {
      widget.task.isCompleted = !widget.task.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => EditTaskWidget(task: widget.task),
        );
      },
      child: ListTile(
        title: Text(widget.task.description),
        leading: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (value) {
            FirestoreDatabase.toggleTaskStatus(
              FirebaseAuth.instance.currentUser!.uid,
              widget.task,
            );
            _handleChecked(value);
          },
        ),
        trailing: IconButton(
          onPressed: () {
            FirestoreDatabase.removeTask(
              FirebaseAuth.instance.currentUser!.uid,
              widget.task,
            );
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
