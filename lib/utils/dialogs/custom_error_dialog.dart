import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

void showCustomErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomErrorDialog(
        title: message,
      );
    },
  );
}

class CustomErrorDialog extends StatelessWidget {
  const CustomErrorDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
      ),
      backgroundColor: kDarkBGColor,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 215,
            child: Padding(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "Error",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: kTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kThemeColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(kRadiusCurve),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Okay",
                          style: TextStyle(
                            color: kTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -40,
            child: CircleAvatar(
              backgroundColor: kThemeColor,
              radius: 40,
              child: Center(
                child: Icon(
                  Icons.error,
                  size: 80,
                  color: kDarkBGColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
