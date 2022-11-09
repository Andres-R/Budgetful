import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_email_cubit.dart';
import 'package:budgetful/database/database_controller.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/email_validator.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _confirmEmail = TextEditingController();

  DatabaseController dbController = DatabaseController();

  void updateUserEmail() async {
    String email = _newEmail.text;
    String confirmed = _confirmEmail.text;

    if (email.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new Email");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new Email");
    } else if (!validateEmail(email)) {
      showCustomErrorDialog(context, "Email entered is not valid");
    } else if (!validateEmail(confirmed)) {
      showCustomErrorDialog(context, "Email confirmed is not valid");
    } else if (email != confirmed) {
      showCustomErrorDialog(context, "Emails entered do not match");
    } else {
      // bool isEmailTaken = await dbController.isEmailTaken(email);

      // if (!isEmailTaken) {
      //   BlocProvider.of<UserEmailCubit>(context)
      //       .updateUserEmail(email, widget.userID);
      //   Navigator.of(context).pop();
      // } else {
      //   showCustomErrorDialog(context, "Email entered is already taken");
      // }
      final navigator = Navigator.of(context);
      final blocProvider = BlocProvider.of<UserEmailCubit>(context);

      bool isEmailTaken = await dbController.isEmailTaken(email);

      if (!isEmailTaken) {
        blocProvider.updateUserEmail(email, widget.userID);
        navigator.pop();
      } else {
        showCustomErrorDialog(context, "Email entered is already taken");
      }
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
          "Edit Email",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Email: ',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                      ),
                    ),
                    BlocBuilder<UserEmailCubit, UserEmailState>(
                      builder: (_, state) {
                        return Text(
                          state.userEmail,
                          style: TextStyle(
                            color: kCurrencyColor,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _newEmail,
                  hint: "Enter new Email",
                  icon: Icons.email,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmEmail,
                  hint: "Confirm new Email",
                  icon: Icons.mail_outline,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUserEmail,
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
