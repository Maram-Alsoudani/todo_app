import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';

class CustomTextFormField extends StatefulWidget {
  final Text label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;

  CustomTextFormField({
    required this.label,
    required this.validator,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isSecured = false;

  @override
  void initState() {
    super.initState();
    if (widget.label.data == "Password" ||
        widget.label.data == "Confirm Password") {
      isSecured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: isSecured,
        cursorColor: AppColors.primary_color,
        decoration: InputDecoration(
          label: widget.label,
          suffixIcon: (widget.label.data == "Password" ||
                  widget.label.data == "Confirm Password")
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSecured = !isSecured;
                    });
                  },
                  icon: Icon(
                    isSecured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primary_color,
                  ),
                )
              : null,
          labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: provider.appTheme == ThemeMode.light
                    ? AppColors.black
                    : AppColors.white,
                fontWeight: FontWeight.bold,
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: AppColors.primary_color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: AppColors.primary_color),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: AppColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: AppColors.red),
          ),
        ),
      ),
    );
  }
}
