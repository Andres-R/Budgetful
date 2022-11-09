import 'package:flutter/material.dart';
import 'package:budgetful/database/database_controller.dart';
import 'package:budgetful/utils/capitalize_first_letter.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
import 'package:budgetful/screens/login_screen.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/dialogs/custom_success_dialog.dart';
import 'package:budgetful/utils/dialogs/custom_email_taken_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late DatabaseController dbController;

  @override
  void initState() {
    super.initState();
    dbController = DatabaseController();
  }

  void signUp() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirm = confirmController.text;

    // check for empty inputs
    if (firstName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a first name");
    } else if (lastName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a last name");
    } else if (username.isEmpty) {
      showCustomErrorDialog(context, "Please enter username");
    } else if (email.isEmpty) {
      showCustomErrorDialog(context, "Please enter email");
    } else if (password.isEmpty) {
      showCustomErrorDialog(context, "Please enter password");
    } else if (confirm.isEmpty) {
      showCustomErrorDialog(context, "Please confirm password");
    }

    // check for standards after form key has been validated
    if (_formKey.currentState!.validate()) {
      if (password != confirm) {
        showCustomErrorDialog(context, "Passwords do not match");
      } else if (firstName.length > nameCharLimit) {
        showCustomErrorDialog(
            context, "First name cannot exceed $nameCharLimit characters");
      } else if (lastName.length > nameCharLimit) {
        showCustomErrorDialog(
            context, "Last name cannot exceed $nameCharLimit characters");
      } else if (username.length > nameCharLimit) {
        showCustomErrorDialog(
            context, "Username cannot exceed $nameCharLimit characters");
      } else if (password.length > passwordLimit) {
        showCustomErrorDialog(
            context, "Password cannot exceed $passwordLimit characters");
      } else if (confirm.length > passwordLimit) {
        showCustomErrorDialog(context,
            "Confirmed password cannot exceed $passwordLimit characters");
      } else {
        _formKey.currentState!.save();

        firstName = capitalizeFirstLetter(firstNameController.text);
        lastName = capitalizeFirstLetter(lastNameController.text);

        // print('firstName: $firstName');
        // print('lastName: $lastName');
        await dbController
            .insertUser(firstName, lastName, username, email, password)
            .then((userData) {
          showCustomSuccessDialog(context, "Account created");
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => LoginForm(),
          //   ),
          //   (Route<dynamic> route) => false,
          // );
        }).catchError((error) {
          //print(error);
          showCustomEmailTakenDialog(context, "$email is already in use");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainBGColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Sign up",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kMainBGColor,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: firstNameController,
                    hint: "First name",
                    icon: Icons.person,
                    obscureText: false,
                    inputType: TextInputType.text,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: lastNameController,
                    hint: "Last name",
                    icon: Icons.abc,
                    obscureText: false,
                    inputType: TextInputType.text,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email,
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: usernameController,
                    hint: "Username",
                    icon: Icons.person_outline,
                    obscureText: false,
                    inputType: TextInputType.text,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    inputType: TextInputType.text,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: confirmController,
                    hint: "Confirm Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                    inputType: TextInputType.text,
                    enableCurrencyMode: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(kRadiusCurve),
                        ),
                        color: kThemeColor,
                      ),
                      child: Center(
                        child: Text(
                          "Sign Up!",
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Have an account?",
                        style: TextStyle(color: kTextColor),
                      ),
                      GestureDetector(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: kThemeColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:budgetful/database/database_controller.dart';
// import 'package:budgetful/utils/capitalize_first_letter.dart';
// import 'package:budgetful/utils/constants.dart';
// import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
// import 'package:budgetful/screens/login_screen.dart';
// import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
// import 'package:budgetful/utils/dialogs/custom_success_dialog.dart';
// import 'package:budgetful/utils/dialogs/custom_email_taken_dialog.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   late DatabaseController dbController;

//   @override
//   void initState() {
//     super.initState();
//     dbController = DatabaseController();
//   }

//   void signUp() async {
//     String firstName = firstNameController.text;
//     String lastName = lastNameController.text;
//     String username = usernameController.text;
//     String email = emailController.text;
//     String password = passwordController.text;
//     String confirm = confirmController.text;

//     if (firstName.isEmpty) {
//       showCustomErrorDialog(context, "Please enter a first name");
//     } else if (lastName.isEmpty) {
//       showCustomErrorDialog(context, "Please enter a last name");
//     } else if (username.isEmpty) {
//       showCustomErrorDialog(context, "Please enter username");
//     } else if (email.isEmpty) {
//       showCustomErrorDialog(context, "Please enter email");
//     } else if (password.isEmpty) {
//       showCustomErrorDialog(context, "Please enter password");
//     } else if (confirm.isEmpty) {
//       showCustomErrorDialog(context, "Please confirm password");
//     }

//     if (_formKey.currentState!.validate()) {
//       if (password != confirm) {
//         showCustomErrorDialog(context, "Passwords do not match");
//       } else {
//         _formKey.currentState!.save();

//         firstName = capitalizeFirstLetter(firstNameController.text);
//         lastName = capitalizeFirstLetter(lastNameController.text);

//         await dbController
//             .insertUser(firstName, lastName, username, email, password)
//             .then((userData) {
//           showCustomSuccessDialog(context, "Account created");
//           // Navigator.pushAndRemoveUntil(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => LoginForm(),
//           //   ),
//           //   (Route<dynamic> route) => false,
//           // );
//         }).catchError((error) {
//           //print(error);
//           showCustomEmailTakenDialog(context, "$email is already in use");
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kMainBGColor,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Sign up",
//           style: TextStyle(
//             color: kThemeColor,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: kMainBGColor,
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: firstNameController,
//                     hint: "First name",
//                     icon: Icons.person,
//                     obscureText: false,
//                     inputType: TextInputType.text,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: lastNameController,
//                     hint: "Last name",
//                     icon: Icons.abc,
//                     obscureText: false,
//                     inputType: TextInputType.text,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: emailController,
//                     hint: "Email",
//                     icon: Icons.email,
//                     obscureText: false,
//                     inputType: TextInputType.emailAddress,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: usernameController,
//                     hint: "Username",
//                     icon: Icons.person_outline,
//                     obscureText: false,
//                     inputType: TextInputType.text,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: passwordController,
//                     hint: "Password",
//                     icon: Icons.lock,
//                     obscureText: true,
//                     inputType: TextInputType.text,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: CustomTextFormField(
//                     controller: confirmController,
//                     hint: "Confirm Password",
//                     icon: Icons.lock_outline,
//                     obscureText: true,
//                     inputType: TextInputType.text,
//                     enableCurrencyMode: false,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: GestureDetector(
//                     onTap: signUp,
//                     child: Container(
//                       height: 55,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(kRadiusCurve),
//                         ),
//                         color: kThemeColor,
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Sign Up!",
//                           style: TextStyle(
//                             color: kTextColor,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         "Have an account?",
//                         style: TextStyle(color: kTextColor),
//                       ),
//                       GestureDetector(
//                         child: Text(
//                           "Sign in",
//                           style: TextStyle(
//                             color: kThemeColor,
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                             (Route<dynamic> route) => false,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
