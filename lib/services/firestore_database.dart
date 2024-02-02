import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_model.dart';

import '../models/user_model.dart';

class FirestoreDatabase {
  static addTask(String uid, Task task) {
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      if (!value.exists) {
        //Add the user document
        FirebaseFirestore.instance.collection("users").doc(uid).set(UserModel(
            uid: uid,
            name: FirebaseAuth.instance.currentUser!.displayName ?? '',
            tasks: [task]).toMap());
      } else {
        // Update tasks array
        FirebaseFirestore.instance.collection("users").doc(uid).update({
          'tasks': FieldValue.arrayUnion([task.toMap()])
        });
      }
    });
  }

  static toggleTaskStatus(String uid, Task task) {
    // Remove older task and toggle isCompleted then update
    removeTask(uid, task);
    task.isCompleted = !task.isCompleted;

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'tasks': FieldValue.arrayUnion([task.toMap()]),
    });
  }

  static editTask(
    String uid,
    Task newTask,
    String? oldDescription,
  ) {
    // Remove older Task to replace with the updated one
    removeTask(uid,
        Task(description: oldDescription!, isCompleted: newTask.isCompleted));

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'tasks': FieldValue.arrayUnion([newTask.toMap()]),
    });
  }

  static removeTask(String uid, Task task) {
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'tasks': FieldValue.arrayRemove([task.toMap()])
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserTasksStream(
      String uid) {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }
}
