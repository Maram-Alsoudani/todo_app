import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/AppColors.dart';
import 'package:to_do_app/CustomTextFormField.dart';

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

    return Stack(
      children: [
        Container(
            color: AppColors.main_background_color_light,
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
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            message: "Register successfully.",
            title: "Success",
            posActionName: "ok");
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              message: "The password provided is too weak.",
              title: "Error",
              posActionName: "ok");
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              message: "The account already exists for that email.",
              title: "Error",
              posActionName: "ok");
          print('The account already exists for that email.');
        }
      } catch (e) {
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            message: e.toString(),
            title: "Error",
            posActionName: "ok");
        print(e);
      }
    }
  }
}
