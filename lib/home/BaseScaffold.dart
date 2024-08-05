import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/DialogUtils.dart';
import 'package:to_do_app/LoginScreen.dart';
import 'package:to_do_app/settings/SettingsScreen.dart';
import 'package:to_do_app/tasksList/TaskBottomSheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/AppConfigProvider.dart';
import '../providers/AuthUserProvider.dart';
import '../providers/ListProvider.dart';

class BaseScaffold extends StatefulWidget {
  final Widget? body;
  final Widget? overlay;

  BaseScaffold({
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
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    var title = _selectedIndex == 0
        ? "${AppLocalizations.of(context)!.app_title}, ${authProvider.currentUser!.name!}"
        : AppLocalizations.of(context)!.settings;

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
              height: 230, // Increased height for app bar
              child: Center(
                child: Text(
                  title,
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

          //logout icon
          Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.logout_outlined),
                onPressed: () {
                  DialogUtils.showMessage(
                      context: context,
                      message:
                          AppLocalizations.of(context)!.confirm_logout_message,
                      title: AppLocalizations.of(context)!.logout,
                      negActionName: AppLocalizations.of(context)!.cancel,
                      posActionName: AppLocalizations.of(context)!.logout,
                      posAction: () {
                        listProvider.tasksList = [];
                        authProvider.currentUser = null;
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.screenRoute);
                      });
                },
              )),
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
              top: 130, // Adjust this value to move the overlay down if needed
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
