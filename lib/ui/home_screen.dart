import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/ui/widgets/add_task_widget.dart';
import 'package:todo_app/ui/widgets/empty_list_widget.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';
import '../services/firestore_database.dart';
import 'widgets/task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tasksStream;
  bool _pressed = false;

  @override
  void initState() {
    _tasksStream = FirestoreDatabase.getUserTasksStream(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          widget.user.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        leading: Image(
          image: NetworkImage(
            widget.user.imageUrl!,
          ),
        ),
        actions: [
          Switch(
              value: _pressed,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggle();
                setState(() {
                  _pressed = !_pressed;
                });
              }),
          IconButton(
            onPressed: () {
              GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const AddTaskWidget(),
        ),
      ),
      body: StreamBuilder(
        stream: _tasksStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              snapshot.data!.data() == null) {
            return const EmptyListWidget();
          }

          UserModel user =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (user.tasks.isEmpty) {
            return const EmptyListWidget();
          }

          return ListView(
            children:
                user.tasks.map((Task task) => TaskWidget(task: task)).toList(),
          );
        },
      ),
    );
  }
}
