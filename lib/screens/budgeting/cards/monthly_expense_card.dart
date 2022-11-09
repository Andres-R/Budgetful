import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:intl/intl.dart';

class MonthlyExpenseCard extends StatelessWidget {
  const MonthlyExpenseCard({
    Key? key,
    required this.cardMonth,
    required this.cardYear,
    required this.checkAmount,
  }) : super(key: key);

  final String cardMonth;
  final int cardYear;
  final double checkAmount;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: kPadding / 2.0,
        horizontal: kPadding,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: kDarkBGColor,
          borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: kPadding, right: kPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardMonth,
                    style: TextStyle(
                      color: kThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cardYear.toString(),
                    style: TextStyle(
                      color: kAccentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "\$${numberFormat.format(checkAmount)}",
                style: TextStyle(
                  color: kCurrencyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
