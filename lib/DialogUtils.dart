import 'package:flutter/material.dart';
import 'package:to_do_app/AppColors.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message),
                )
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
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionName,
              style: TextStyle(color: AppColors.primary_color))));
    }
    if (negActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(
            negActionName,
            style: TextStyle(color: AppColors.primary_color),
          )));
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: title == "Error" ? AppColors.red : AppColors.black),
            ),
            actions: actions,
          );
        });
  }
}
