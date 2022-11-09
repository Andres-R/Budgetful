import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: kTextColor,
        fontSize: 20,
      ),
    );
  }
}
