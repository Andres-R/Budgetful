import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.text,
    required this.icon,
    required this.controller,
    required this.input,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType input;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: input,
      cursorColor: kMainBGColor,
      style: TextStyle(color: kMainBGColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: kMainBGColor),
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      // obscureText: isPasswordType,
      // enableSuggestions: !isPasswordType,
      // autocorrect: !isPasswordType,
      // keyboardType: isPasswordType
      //     ? TextInputType.visiblePassword
      //     : TextInputType.text,
    );
  }
}
