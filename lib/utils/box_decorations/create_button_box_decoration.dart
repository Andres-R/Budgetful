import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

class CreateButtonBoxDecoration extends StatelessWidget {
  const CreateButtonBoxDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.all(
          Radius.circular(kRadiusCurve),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Create",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
