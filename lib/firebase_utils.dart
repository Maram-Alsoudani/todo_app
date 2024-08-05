import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyUser.dart';
import 'Task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
            Task.fromFireStore(snapshot.data()!),
        toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId);
    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> updateTask(
      Task task, String key, dynamic newVal, String uId) {
    return getTasksCollection(uId)
        .doc(task.id)
        .update({key: newVal}).timeout(Duration(seconds: 1), onTimeout: () {
      print("task updated successfully ");
    });
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (myUser, option) => myUser.toFireStore());
  }

  static addUserToFireStore(MyUser myUser) {
    getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uid) async {
    var querySnapshot = await getUsersCollection().doc(uid).get();
    return querySnapshot.data();
  }
}
