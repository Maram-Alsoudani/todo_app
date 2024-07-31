import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/Task.dart';
import 'package:to_do_app/firebase_utils.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';

import '../providers/ListProvider.dart';

class TaskBottomSheet extends StatefulWidget {
  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String title = "";
  String description = "";
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy ').format(selectedDate);
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);

    return SingleChildScrollView(
      child: Container(
        color: provider.appTheme == ThemeMode.light
            ? AppColors.white
            : AppColors.black_dark,
        child: Padding(
          padding: EdgeInsets.only(
            left: 44,
            right: 44,
            top: 33,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.add_new_task,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: provider.appTheme == ThemeMode.light
                        ? AppColors.black
                        : AppColors.white),
              ),
              SizedBox(
                height: 35,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_your_task;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enter_your_task,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                color: provider.appTheme == ThemeMode.light
                                    ? AppColors.black
                                    : AppColors.white),
                      ),
                      onChanged: (text) {
                        title = text;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_description;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        description = text;
                      },
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.enter_description,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                color: provider.appTheme == ThemeMode.light
                                    ? AppColors.black
                                    : AppColors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.select_date,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: provider.appTheme == ThemeMode.light
                              ? AppColors.black
                              : AppColors.white,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showCalender();
                      },
                      child: Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 17,
                              color: provider.appTheme == ThemeMode.light
                                  ? AppColors.grey
                                  : AppColors.white,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          addTask();
                        },
                        splashColor: AppColors.primary_color.withOpacity(0.3),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.primary_color,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task =
          Task(title: title, description: description, dateTime: selectedDate);
      FirebaseUtils.addTaskToFireStore(task).timeout(Duration(seconds: 1),
          onTimeout: () {
        print("task added succefully");
        listProvider.getAllTasksFromFireStore();
        Navigator.pop(context);
      });
    }
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary_color, // header background color
              onPrimary: AppColors.white, // header text color
              onSurface: AppColors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary_color, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    selectedDate = chosenDate ?? selectedDate;
    setState(() {});
  }
}
