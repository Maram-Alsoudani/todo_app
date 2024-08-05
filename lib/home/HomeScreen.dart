import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/providers/AuthUserProvider.dart';
import 'package:to_do_app/tasksList/TaskListItem.dart';

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
    var provider = Provider.of<AppConfigProvider>(context);

    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }
    var provide = Provider.of<AppConfigProvider>(context);
    return BaseScaffold(
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
            listProvider.changeSelectedDate(
                selectedDate, authProvider.currentUser!.id!);
          },
          locale: provider.appLanguage == "ar" ? "ar" : "en",
          headerProps: EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: EasyDayProps(
            width: 58,
            height: 79,
          ),
          itemBuilder: (BuildContext context,
              DateTime date,
              bool isSelected,
              VoidCallback onTap,) {
            DateTime today = DateTime.now();
            DateTime lastSelectableDate = today.add(Duration(days: 365));

            bool isSelectable =
                date.isAfter(today.subtract(Duration(days: 1))) &&
                    date.isBefore(lastSelectableDate);

            var locale = provider.appLanguage == 'ar' ? 'ar' : 'en';
            var day = DateFormat.d(locale).format(date);
            var dayName = DateFormat.E(locale).format(date);

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
                      dayName,
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
