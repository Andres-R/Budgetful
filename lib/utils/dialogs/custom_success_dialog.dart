import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

void showCustomSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomSuccessDialog(
        title: message,
      );
    },
  );
}

class CustomSuccessDialog extends StatelessWidget {
  const CustomSuccessDialog({
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
                    "Success!",
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
                        color: kCurrencyColor,
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
              backgroundColor: kCurrencyColor,
              radius: 40,
              child: CircleAvatar(
                backgroundColor: kDarkBGColor,
                radius: 30,
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: kTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
