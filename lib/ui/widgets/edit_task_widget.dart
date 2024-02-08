import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../services/firestore_database.dart';
import '../utilities/validator.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({super.key, required this.task});
  final Task task;

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionTextController = TextEditingController();
  String? _oldDescription;

  @override
  void initState() {
    _oldDescription = widget.task.description;
    _descriptionTextController.text = widget.task.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Edit Task'),
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
            child: const Text("Edit"),
            onPressed: () {
              try {
                editTask(_descriptionTextController.text, _oldDescription);
              } on Exception catch (e) {
                showDialog(
                    context: context, builder: (context) => Text(e.toString()));
              }
            }),
      ],
    );
  }

  void editTask(
    String description,
    String? oldDescription,
  ) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      FirestoreDatabase.editTask(FirebaseAuth.instance.currentUser!.uid,
          Task(description: description), oldDescription);
      Navigator.of(context).pop();
    }
  }
}
