import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_password_cubit.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isPasswordVisible = false;

  void updateUserPassword() {
    String password = _newPassword.text;
    String confirmed = _confirmPassword.text;

    if (password.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new password");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new password");
    } else if (password != confirmed) {
      showCustomErrorDialog(context, "Passwords entered do not match");
    } else if (password.length > passwordLimit) {
      showCustomErrorDialog(
          context, "Password cannot exceed $passwordLimit characters");
    } else if (confirmed.length > passwordLimit) {
      showCustomErrorDialog(context,
          "Confirmed password cannot exceed $passwordLimit characters");
    } else {
      BlocProvider.of<UserPasswordCubit>(context)
          .updateUserPassword(password, widget.userID);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Edit Password",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        color: kMainBGColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current password: ',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                        BlocBuilder<UserPasswordCubit, UserPasswordState>(
                          builder: (_, state) {
                            if (isPasswordVisible) {
                              return Text(
                                state.userPassword,
                                style: TextStyle(
                                  color: kCurrencyColor,
                                  fontSize: 18,
                                ),
                              );
                            } else {
                              String hidden = '';
                              for (int i = 0;
                                  i < state.userPassword.length;
                                  i++) {
                                hidden += '*';
                              }
                              return Text(
                                hidden,
                                style: TextStyle(
                                  color: kCurrencyColor,
                                  fontSize: 18,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: kDarkBGColor,
                        ),
                        child: Center(
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_outlined,
                            color: kCurrencyColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _newPassword,
                  hint: "Enter new password",
                  icon: Icons.text_snippet,
                  obscureText: true,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmPassword,
                  hint: "Confirm new password",
                  icon: Icons.text_snippet_outlined,
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
                  onTap: updateUserPassword,
                  child: const MakeChangeButtonBoxDecoration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MakeChangeButtonBoxDecoration extends StatelessWidget {
  const MakeChangeButtonBoxDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Make change",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
