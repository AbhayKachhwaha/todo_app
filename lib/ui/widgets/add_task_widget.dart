import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firestore_database.dart';
import 'package:todo_app/ui/utilities/validator.dart';

import '../../models/task_model.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Add Task'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descriptionTextController,
                validator: (value) => Validator.validateDescription(value),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            child: const Text("Add"),
            onPressed: () {
              try {
                addTask(
                  _descriptionTextController.text,
                );
              } catch (e) {
                showDialog(
                    context: context, builder: (context) => Text(e.toString()));
              }
            }),
      ],
    );
  }

  void addTask(
    String description,
  ) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      FirestoreDatabase.addTask(
        FirebaseAuth.instance.currentUser!.uid,
        Task(description: description),
      );
      Navigator.of(context).pop();
    }
  }
}
