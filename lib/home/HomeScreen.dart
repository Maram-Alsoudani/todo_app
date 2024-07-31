import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/tasksList/TaskListItem.dart';

import '../Task.dart';
import '../firebase_utils.dart';
import '../providers/AppConfigProvider.dart';
import '../providers/ListProvider.dart';
import 'BaseScaffold.dart';

class HomeScreen extends StatefulWidget {
  static const screenRoute = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore();
    }
    var provide = Provider.of<AppConfigProvider>(context);
    return BaseScaffold(
      title: AppLocalizations.of(context)!.app_title,
      body:
          //tasks list
          Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listProvider.tasksList.length,
                itemBuilder: (context, index) {
                  return TasksListItem(task: listProvider.tasksList[index]);
                },
              ),
            ),
          ],
        ),
      ),
      overlay: Center(
        child: EasyDateTimeLine(
          initialDate: listProvider.selectedDate,
          onDateChange: (selectedDate) {
            listProvider.changeSelectedDate(selectedDate);
          },
          headerProps: EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: EasyDayProps(
            width: 58,
            height: 79,
          ),
          itemBuilder: (
            BuildContext context,
            DateTime date,
            bool isSelected,
            VoidCallback onTap,
          ) {
            DateTime today = DateTime.now();
            DateTime lastSelectableDate = today.add(Duration(days: 365));

            bool isSelectable =
                date.isAfter(today.subtract(Duration(days: 1))) &&
                    date.isBefore(lastSelectableDate);

            return InkResponse(
              onTap: isSelectable ? onTap : null,
              child: Container(
                width: 58,
                height: 79,
                decoration: BoxDecoration(
                  color: provide.appTheme == ThemeMode.light
                      ? AppColors.white
                      : AppColors.black_dark,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: provide.appTheme == ThemeMode.light
                            ? (isSelected
                                ? AppColors.primary_color
                                : (isSelectable ? Colors.black : Colors.grey))
                            : (isSelected
                                ? AppColors.primary_color
                                : (isSelectable ? Colors.white : Colors.grey)),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      EasyDateFormatter.shortDayName(date, "en_US"),
                      style: TextStyle(
                        color: provide.appTheme == ThemeMode.light
                            ? (isSelected
                                ? AppColors.primary_color
                                : (isSelectable ? Colors.black : Colors.grey))
                            : (isSelected
                                ? AppColors.primary_color
                                : (isSelectable ? Colors.white : Colors.grey)),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
