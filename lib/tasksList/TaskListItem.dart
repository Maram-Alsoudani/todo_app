import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/EditTaskScreen.dart';
import 'package:to_do_app/firebase_utils.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';
import 'package:to_do_app/providers/AuthUserProvider.dart';

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
    var authProvider = Provider.of<AuthUserProvider>(context);
    bool isDone = widget.task.isDone;
    final now = DateTime.now();
    final formattedTime = '${now.hour}:${now.minute}';

    var uid = authProvider.currentUser!.id!;

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
                    FirebaseUtils.deleteTaskFromFireStore(widget.task, uid)
                        .then((value) {
                      print("task deleted successfully");
                      listProvider.getAllTasksFromFireStore(uid);
                    }).timeout(Duration(seconds: 1), onTimeout: () {});
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
                    Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDone
                              ? AppColors.green
                              : AppColors.primary_color),
                    ),
                    isDone
                        ? Text(
                            AppLocalizations.of(context)!.done,
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
                                  widget.task, "idDone", true, uid);
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
