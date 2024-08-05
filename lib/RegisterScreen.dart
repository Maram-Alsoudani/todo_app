import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/CustomTextFormField.dart';
import 'package:to_do_app/LoginScreen.dart';
import 'package:to_do_app/MyUser.dart';
import 'package:to_do_app/firebase_utils.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';
import 'package:to_do_app/providers/AuthUserProvider.dart';

import 'DialogUtils.dart';

class RegisterScreen extends StatefulWidget {
  static const String screenRoute = "register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    var provider = Provider.of<AppConfigProvider>(context);

    return Stack(
      children: [
        Container(
            color: provider.appTheme == ThemeMode.light
                ? AppColors.main_background_color_light
                : AppColors.main_background_color_dark,
            child: Image(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background.png"))),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 70,
              title: Text(
                localization.create_account,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        CustomTextFormField(
                            label: Text(localization.user_name),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Please enter your username.";
                              }
                              return null;
                            },
                            controller: usernameController),
                        CustomTextFormField(
                            label: Text(localization.email),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Please enter your email.";
                              }
                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(text);
                              if (!emailValid) {
                                return "Email is not valid, pleas enter a valid email.";
                              }
                              return null;
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress),
                        CustomTextFormField(
                          label: Text(localization.password),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Please enter your password.";
                            }
                            if (text.length < 6) {
                              return "password should has at least 6 characters.";
                            }
                            return null;
                          },
                          controller: passwordController,
                        ),
                        CustomTextFormField(
                            label: Text(localization.confirm_password),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Please confirm password";
                              }
                              if (passwordController.text != text) {
                                return "passwords do not match";
                              }
                              return null;
                            },
                            controller: confirmPasswordController)
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: Text(
                    localization.create_account,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff3598db)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                )
              ]),
            ))
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      //show loading
      DialogUtils.showLoading(context: context, message: "Loading..");
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        MyUser myUser = MyUser(
            email: emailController.text,
            name: usernameController.text,
            id: credential.user?.uid ?? "");
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.changeUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!.register_successfully,
            title: AppLocalizations.of(context)!.success,
            posAction: () {
              Navigator.pushReplacementNamed(context, LoginScreen.screenRoute);
            },
            posActionName: AppLocalizations.of(context)!.ok);
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              message: AppLocalizations.of(context)!
                  .the_password_provided_is_too_weak,
              title: AppLocalizations.of(context)!.error,
              posActionName: AppLocalizations.of(context)!.ok);
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              message: AppLocalizations.of(context)!
                  .the_account_already_exists_for_that_email,
              title: AppLocalizations.of(context)!.error,
              posActionName: AppLocalizations.of(context)!.ok);
          print('The account already exists for that email.');
        } else if (e.code == 'network-request-failed') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!.network_error,
            posActionName: AppLocalizations.of(context)!.ok,
            title: AppLocalizations.of(context)!.error,
          );
          print('network-request-failed');
        } else {
          DialogUtils.showMessage(
            context: context,
            message: "Error: ${e.toString()}",
            posActionName: AppLocalizations.of(context)!.ok,
            title: AppLocalizations.of(context)!.error,
          );
          print("FirebaseAuthException: ${e.message}");
        }
      }
    }
  }
}
