import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';
import 'package:to_do_app/providers/AuthUserProvider.dart';
import 'package:to_do_app/providers/ListProvider.dart';

import 'Task.dart';
import 'firebase_utils.dart';

class EditTaskScreen extends StatefulWidget {
  static const String screenRoute = "edit_task_screen";

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  // DateTime selectedDate = DateTime.now();
  late ListProvider listProvider;
  late AppConfigProvider provider;
  late AuthUserProvider authProvider;
  late String uid;

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);
    _selectedDate = task.dateTime;
    listProvider = Provider.of<ListProvider>(context);
    final localization = AppLocalizations.of(context)!;
    provider = Provider.of<AppConfigProvider>(context);
    String formattedDate = DateFormat('dd-MM-yyyy ').format(_selectedDate);
    authProvider = Provider.of<AuthUserProvider>(context);
    uid = authProvider.currentUser!.id!;
    return Scaffold(
      backgroundColor: provider.appTheme == ThemeMode.light
          ? AppColors.main_background_color_light
          : AppColors.main_background_color_dark,
      body: Stack(
        children: [
          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.primary_color,
              height: 200, // Increased height for app bar
              child: Center(
                child: Text(
                  localization.app_title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: provider.appTheme == ThemeMode.light
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: 24, // Adjust font size if needed
                      ),
                ),
              ),
            ),
          ),
          // Body
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(top: 200),
              // Adjust margin to accommodate new app bar height
              // Empty container if Settings icon is selected
            ),
          ),
          // Optional overlay like calendar
          Positioned(
              top: 150,
              left: 30,
              right: 30,
              child: Container(
                padding: EdgeInsets.all(20),
                width: 100,
                height: 550,
                decoration: BoxDecoration(
                    color: provider.appTheme == ThemeMode.light
                        ? AppColors.white
                        : AppColors.black_dark,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      localization.edit_task,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: provider.appTheme == ThemeMode.light
                              ? AppColors.black
                              : AppColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _titleController,
                      cursorColor: AppColors.primary_color,
                      style: TextStyle(
                        color: provider.appTheme == ThemeMode.light
                            ? AppColors.black
                            : AppColors.white,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary_color),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors
                                  .black), // Bottom border color when not focused
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _descriptionController,
                      style: TextStyle(
                        color: provider.appTheme == ThemeMode.light
                            ? AppColors.black
                            : AppColors.white,
                      ),
                      maxLines: 4,
                      cursorColor: AppColors.primary_color,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary_color),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors
                                  .black), // Bottom border color when not focused
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCalendar(context);
                      },
                      child: Text(
                        "${_selectedDate.toLocal()}".split(' ')[0],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 17,
                              color: provider.appTheme == ThemeMode.light
                                  ? AppColors.grey
                                  : AppColors.white,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveChanges(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.primary_color),
                        ),
                        child: Text(localization.save_changes,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: AppColors.white, fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> showCalendar(BuildContext context) async {
    DateTime initialDate = _selectedDate;
    DateTime firstDate = initialDate;
    DateTime lastDate = initialDate.add(Duration(days: 365));

    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: provider.appTheme == ThemeMode.light
              ? Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primary_color, // Header background color
                    onPrimary: AppColors.white, // Header text color
                    onSurface: AppColors.black, // Body text color
                  ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                      foregroundColor:
                          AppColors.primary_color, // Button text color
                    ),
                  ),
                )
              : Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.primary_color, // Header background color
                    onPrimary: AppColors.black, // Header text color
                    onSurface: AppColors.white, // Body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColors.primary_color, // Button text color
                    ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (chosenDate != null && chosenDate != _selectedDate) {
      setState(() {
        _selectedDate = chosenDate;
      });
    }
  }

  void _saveChanges(BuildContext context) async {
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    task.title = _titleController.text;
    task.description = _descriptionController.text;
    task.dateTime = _selectedDate;
    await FirebaseUtils.updateTask(task, 'title', task.title, uid);
    await FirebaseUtils.updateTask(task, 'description', task.description, uid);
    await FirebaseUtils.updateTask(
        task, 'dateTime', task.dateTime.millisecondsSinceEpoch, uid);
    listProvider.updateTask(task);
    Navigator.pop(context, _selectedDate);
  }
}
