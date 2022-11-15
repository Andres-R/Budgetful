import 'package:budgetful/utils/capitalize_first_letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_last_name_cubit.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class EditLastNameScreen extends StatefulWidget {
  const EditLastNameScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<EditLastNameScreen> createState() => _EditLastNameScreenState();
}

class _EditLastNameScreenState extends State<EditLastNameScreen> {
  final TextEditingController _newLastName = TextEditingController();
  final TextEditingController _confirmLastName = TextEditingController();

  void updateUserLastName() {
    String lastName = _newLastName.text;
    String confirmed = _confirmLastName.text;

    if (lastName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new last name");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new last name");
    } else if (lastName != confirmed) {
      showCustomErrorDialog(context, "Last names entered do not match");
    } else if (lastName.length > nameCharLimit) {
      showCustomErrorDialog(
          context, "Last name cannot exceed $nameCharLimit characters");
    } else if (confirmed.length > nameCharLimit) {
      showCustomErrorDialog(context,
          "Confirmed last name cannot exceed $nameCharLimit characters");
    } else {
      lastName = capitalizeFirstLetter(_newLastName.text);

      BlocProvider.of<UserLastNameCubit>(context)
          .updateUserLastName(lastName, widget.userID);

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
          "Edit last name",
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
                      'Current last name: ',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                      ),
                    ),
                    BlocBuilder<UserLastNameCubit, UserLastNameState>(
                      builder: (_, state) {
                        return Text(
                          state.userLastName,
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
                  controller: _newLastName,
                  hint: "Enter new last name",
                  icon: Icons.text_snippet,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmLastName,
                  hint: "Confirm new last name",
                  icon: Icons.text_snippet_outlined,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                  next: false,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUserLastName,
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
