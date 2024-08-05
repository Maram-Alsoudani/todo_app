import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    var provider = Provider.of<AppConfigProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        // Prevent dismissing the dialog by tapping outside
        builder: (context) {
          return AlertDialog(
            backgroundColor: provider.appTheme == ThemeMode.light
                ? AppColors.white
                : AppColors.black_dark,
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary_color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: provider.appTheme == ThemeMode.light
                          ? AppColors.black
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String title = "",
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    var provider = Provider.of<AppConfigProvider>(context, listen: false);
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(
            posActionName,
            style: TextStyle(color: AppColors.primary_color),
          )));
    }
    if (negActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(
            negActionName,
            style: TextStyle(
                color: provider.appTheme == ThemeMode.light
                    ? AppColors.black
                    : AppColors.white),
          )));
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: provider.appTheme == ThemeMode.light
                ? AppColors.white
                : AppColors.black_dark,
            content: Text(
              message,
              style: TextStyle(
                color: provider.appTheme == ThemeMode.light
                    ? AppColors.black
                    : AppColors.white,
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: title == AppLocalizations.of(context)!.error
                      ? AppColors.red
                      : provider.appTheme == ThemeMode.light
                          ? AppColors.black
                          : AppColors.white,
                  fontSize: 22),
            ),
            actions: actions,
          );
        });
  }
}
