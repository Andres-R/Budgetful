import 'package:flutter/material.dart';
import 'package:budgetful/database/database_controller.dart';
import 'package:budgetful/screens/home_screen.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
import 'package:budgetful/screens/signup_screen.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late DatabaseController dbController;

  @override
  void initState() {
    super.initState();
    dbController = DatabaseController();
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      showCustomErrorDialog(context, "Please enter email");
    } else if (password.isEmpty) {
      showCustomErrorDialog(context, "Please enter password");
    } else {
      await dbController.getUser(email, password).then((userData) {
        if (userData['userID'] != -1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userID: userData['userID']),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          showCustomErrorDialog(context, "Incorrect Email or Password");
        }
      }).catchError((error) {
        showCustomErrorDialog(context, "Failed to login");
      });
    }
  }

  void loginAsGuest() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userID: kGuestID),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainBGColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kMainBGColor,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: emailController,
                  hint: "Email",
                  icon: Icons.email,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  enableCurrencyMode: false,
                  next: true,
                  focusNode: null,
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
                  next: false,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: login,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(kRadiusCurve)),
                      color: kThemeColor,
                    ),
                    child: Center(
                      child: Text(
                        "Login",
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
                      "Don't have an account?",
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: kThemeColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: loginAsGuest,
                  child: Container(
                    color: kMainBGColor,
                    child: Text(
                      'Continue as guest',
                      style: TextStyle(color: kThemeColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
