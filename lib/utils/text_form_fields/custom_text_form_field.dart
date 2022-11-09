import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.obscureText,
    required this.inputType,
    required this.enableCurrencyMode,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final bool enableCurrencyMode;

  static const String _locale = 'en';

  String get _currency {
    return NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: TextStyle(color: kTextColor),
      cursorColor: kTextColor,
      textInputAction: TextInputAction.done,
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hint == "Confirm Password"
              ? "Confirm password"
              : "Enter $hint";
        }
        if (hint == "Email" && !validateEmail(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: kThemeColor),
        ),
        prefixText: enableCurrencyMode ? _currency : '',
        prefixIcon: Icon(icon, color: kThemeColor),
        hintText: hint,
        hintStyle: TextStyle(color: kTextColor),
        //labelText: hint,
        //labelStyle: TextStyle(color: Colors.grey.shade700),
        fillColor: kDarkBGColor,
        filled: true,
        //floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      inputFormatters: enableCurrencyMode
          ? [
              CurrencyTextInputFormatter(
                decimalDigits: 2,
                symbol: '',
              ),
            ]
          : [],
    );
  }
}
