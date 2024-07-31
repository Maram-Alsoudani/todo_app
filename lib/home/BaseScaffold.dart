import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/settings/SettingsScreen.dart';
import 'package:to_do_app/tasksList/TaskBottomSheet.dart';

import '../providers/AppConfigProvider.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget? body;
  final Widget? overlay;

  BaseScaffold({
    required this.title,
    this.body,
    this.overlay,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

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
                  widget.title,
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
              child: _selectedIndex == 0
                  ? widget.body // Show body if List icon is selected
                  : SettingsScreen(), // Empty container if Settings icon is selected
            ),
          ),
          // Optional overlay like calendar
          if (widget.overlay != null && _selectedIndex == 0)
            Positioned(
              top: 100, // Adjust this value to move the overlay down if needed
              left: 0,
              right: 0,
              child: widget.overlay!,
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: provider.appTheme == ThemeMode.light
            ? AppColors.white
            : AppColors.black_dark,
        notchMargin: 8,
        shape: CircularNotchedRectangle(),
        child: SingleChildScrollView(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showTaskBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => TaskBottomSheet(),
    );
  }
}
