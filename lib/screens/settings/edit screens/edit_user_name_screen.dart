import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_name_cubit.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class EditUserNameScreen extends StatefulWidget {
  const EditUserNameScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<EditUserNameScreen> createState() => _EditUserNameScreenState();
}

class _EditUserNameScreenState extends State<EditUserNameScreen> {
  final TextEditingController _newUserName = TextEditingController();
  final TextEditingController _confirmUserName = TextEditingController();

  void updateUsername() {
    String userName = _newUserName.text;
    String confirmed = _confirmUserName.text;

    if (userName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new username");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new username");
    } else if (userName != confirmed) {
      showCustomErrorDialog(context, "Usernames entered do not match");
    } else if (userName.length > nameCharLimit) {
      showCustomErrorDialog(
          context, "Username cannot exceed $nameCharLimit characters");
    } else if (confirmed.length > nameCharLimit) {
      showCustomErrorDialog(context,
          "Username confirmed cannot exceed $nameCharLimit characters");
    } else {
      BlocProvider.of<UserNameCubit>(context)
          .updateUserName(userName, widget.userID);

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
          "Edit Username",
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
                      'Current username: ',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                      ),
                    ),
                    BlocBuilder<UserNameCubit, UserNameState>(
                      builder: (_, state) {
                        return Text(
                          state.userName,
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
                  controller: _newUserName,
                  hint: "Enter new username",
                  icon: Icons.text_snippet,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmUserName,
                  hint: "Confirm new username",
                  icon: Icons.text_snippet_outlined,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUsername,
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
