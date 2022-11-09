import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

class AddButtonBoxDecoration extends StatelessWidget {
  const AddButtonBoxDecoration({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kPadding,
          vertical: kPadding / 2,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
