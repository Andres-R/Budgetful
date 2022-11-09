import 'package:budgetful/utils/capitalize_first_letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_first_name_cubit.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class EditFirstNameScreen extends StatefulWidget {
  const EditFirstNameScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<EditFirstNameScreen> createState() => _EditFirstNameScreenState();
}

class _EditFirstNameScreenState extends State<EditFirstNameScreen> {
  final TextEditingController _newFirstName = TextEditingController();
  final TextEditingController _confirmFirstName = TextEditingController();

  void updateUserFirstName() {
    String firstName = _newFirstName.text;
    String confirmed = _confirmFirstName.text;

    if (firstName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new first name");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new first name");
    } else if (firstName != confirmed) {
      showCustomErrorDialog(context, "First names entered do not match");
    } else if (firstName.length > nameCharLimit) {
      showCustomErrorDialog(
          context, "First name cannot exceed $nameCharLimit characters");
    } else if (confirmed.length > nameCharLimit) {
      showCustomErrorDialog(context,
          "Confirmed first name cannot exceed $nameCharLimit characters");
    } else {
      firstName = capitalizeFirstLetter(_newFirstName.text);

      BlocProvider.of<UserFirstNameCubit>(context)
          .updateUserFirstName(firstName, widget.userID);

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
          "Edit first name",
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
                      'Current first name: ',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                      ),
                    ),
                    BlocBuilder<UserFirstNameCubit, UserFirstNameState>(
                      builder: (_, state) {
                        return Text(
                          state.userFirstName,
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
                  controller: _newFirstName,
                  hint: "Enter new first name",
                  icon: Icons.text_snippet,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmFirstName,
                  hint: "Confirm new first name",
                  icon: Icons.text_snippet_outlined,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUserFirstName,
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
