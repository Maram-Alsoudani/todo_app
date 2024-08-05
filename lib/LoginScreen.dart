import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/RegisterScreen.dart';
import 'package:to_do_app/firebase_utils.dart';
import 'package:to_do_app/home/HomeScreen.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';
import 'package:to_do_app/providers/AuthUserProvider.dart';

import 'AppColors.dart';
import 'CustomTextFormField.dart';
import 'DialogUtils.dart';

class LoginScreen extends StatefulWidget {
  static const String screenRoute = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                localization.login,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Expanded(
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
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      localization.login,
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
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RegisterScreen.screenRoute);
                      },
                      child: Text(
                        localization.or_create_an_account,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Color(0xff3598db)),
                      ))
                ]),
              ),
            ))
      ],
    );
  }

  // void login() async {
  //   //show loading
  //   // DialogUtils.showLoading(context: context, message: "Loading..");
  //   try {
  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text
  //     );
  //     //hide loading
  //     DialogUtils.hideLoading(context);
  //     //show message
  //     DialogUtils.showMessage(context: context, message: "Login successfully.", posActionName: "ok", posAction: (){
  //       Navigator.of(context).pushNamed( HomeScreen.screenRoute);
  //     });
  //
  //     print(credential.user?.uid??"");
  //
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-credential') {
  //       //hide loading
  //       DialogUtils.hideLoading(context);
  //       //show message
  //       DialogUtils.showMessage(context: context, message: "No user found for that email and password.", posActionName: "ok");
  //       print('No user found for that email and password.');
  //     }
  //   }catch(e){
  //     // //hide loading
  //     // DialogUtils.hideLoading(context);
  //     // //show message
  //     // DialogUtils.showMessage(context: context, message: e.toString(), posActionName: "ok");
  //     print(">>>>>>>>>>>> ${e.toString()}");
  //   }
  // }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      // Show loading
      DialogUtils.showLoading(context: context, message: "Loading..");
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? "");

        if (user == null) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            message: "user data not found",
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
          );
          return;
        }

        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.changeUser(user);
        // Hide loading
        DialogUtils.hideLoading(context);
        // Show success message
        DialogUtils.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.login_successfully,
          title: AppLocalizations.of(context)!.success,
          posActionName: AppLocalizations.of(context)!.ok,
          posAction: () {
            Navigator.of(context).pushNamed(HomeScreen.screenRoute);
          },
        );

        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        // Hide loading
        DialogUtils.hideLoading(context);

        if (e.code == 'invalid-credential') {
          DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!
                .no_user_found_for_that_email_and_password,
            posActionName: AppLocalizations.of(context)!.ok,
            title: AppLocalizations.of(context)!.error,
          );
          print('No user found for that email.');
        } else if (e.code == 'network-request-failed') {
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

//  void login() async {
//     if (formKey.currentState?.validate() == true) {
//       // Show loading
//       DialogUtils.showLoading(context: context, message: "Loading..");
//       try {
//         final credential =
//             await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//        var user= await FirebaseUtils.readUserFromFireStore(credential.user?.uid??"");
//
//        if(user==null){
//          return;
//        }
//         var authProvider=Provider.of<AuthUserProvider>(context, listen: false);
//         authProvider.changeUser(user);
//         // Hide loading
//         DialogUtils.hideLoading(context);
//         // Show success message
//         DialogUtils.showMessage(
//           context: context,
//           message: "Login successfully.",
//           title: "Success",
//           posActionName: "ok",
//           posAction: () {
//             Navigator.of(context).pushNamed(HomeScreen.screenRoute);
//           },
//         );
//
//         print(credential.user?.uid ?? "");
//       } on FirebaseAuthException catch (e) {
//         // Hide loading
//         DialogUtils.hideLoading(context);
//
//         if (e.code == 'invalid-credential') {
//           DialogUtils.showMessage(
//             context: context,
//             message: "No user found for that email and password.",
//             posActionName: "ok",
//             title: "Error",
//           );
//           print('No user found for that email.');
//         } else {
//           DialogUtils.showMessage(
//             context: context,
//             message: "Error: ${e.toString()}",
//             posActionName: "ok",
//             title: "Error",
//           );
//           print("FirebaseAuthException: ${e.message}");
//         }
//       } catch (e) {
//         // Hide loading
//         DialogUtils.hideLoading(context);
//
//         // Show error message
//         DialogUtils.showMessage(
//           context: context,
//           message: "network error",
//           posActionName: "ok",
//           title: "Error",
//         );
//         print("Unexpected error: ${e.toString()}");
//       }
//     }
//   }
}
