import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Task.dart';
import '../firebase_utils.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasksList = tasksList.where((task) {
      if (selectedDate.day == task.dateTime.day &&
          selectedDate.month == task.dateTime.month &&
          selectedDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();

    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeSelectedDate(DateTime newSelectedDate, String uId) {
    selectedDate = newSelectedDate;
    getAllTasksFromFireStore(uId);
  }

  void updateTask(Task updatedTask) {
    final index = tasksList.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasksList[index] = updatedTask;
      notifyListeners();
    }
  }
}
