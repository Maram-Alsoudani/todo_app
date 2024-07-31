import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/EditTaskScreen.dart';
import 'package:to_do_app/firebase_utils.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';

import '../Task.dart';
import '../providers/ListProvider.dart';

class TasksListItem extends StatefulWidget {
  Task task;

  TasksListItem({required this.task});

  @override
  State<TasksListItem> createState() => _TasksListItemState();
}

class _TasksListItemState extends State<TasksListItem> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    // Define the format for hours and minutes in am/pm
    final DateFormat formatter = DateFormat('hh:mm a');
    // Format the DateTime object
    final String formattedTime = formatter.format(widget.task.dateTime);

    bool isDone = widget.task.isDone;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EditTaskScreen.screenRoute,
            arguments: widget.task);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Border radius for Slidable
          child: Slidable(
            startActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    FirebaseUtils.deleteTaskFromFireStore(widget.task)
                        .timeout(Duration(seconds: 1), onTimeout: () {
                      print("task deleted successfully");
                      listProvider.getAllTasksFromFireStore();
                    });
                  },
                  backgroundColor: AppColors.red,
                  label: AppLocalizations.of(context)!.delete,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: provider.appTheme == ThemeMode.light
                    ? AppColors.white
                    : AppColors.black_dark,
                borderRadius:
                    BorderRadius.circular(20), // Border radius for Container
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color:
                            isDone ? AppColors.green : AppColors.primary_color,
                        width: 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: isDone
                                      ? AppColors.green
                                      : AppColors.primary_color),
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(
                              color: provider.appTheme == ThemeMode.light
                                  ? Colors.grey
                                  : AppColors.white),
                        ),
                      ],
                    ),
                    isDone
                        ? Text(
                            'Done!',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: AppColors.green),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                  AppColors.primary_color),
                            ),
                            onPressed: () async {
                              await FirebaseUtils.updateTask(
                                  widget.task, "idDone", true);
                              setState(() {
                                widget.task.isDone = true;
                              });
                            },
                            child: Icon(
                              Icons.check,
                              color: AppColors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
