import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    Key? key,
    required this.budget,
    required this.budgetLimit,
    required this.spent,
  }) : super(key: key);

  final String budget;
  final double budgetLimit;
  final double spent;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    double cardHeight = 150;
    double cardWidth = determineCardWidth(budget); // original 170
    double progressBarHeight = 100;
    double progressBarWidth = 10;

    return Padding(
      padding: EdgeInsets.all(kPadding / 2),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          color: kDarkBGColor,
          borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
        ),
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budget,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: 'Limit: ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${numberFormat.format(budgetLimit)}',
                          style: TextStyle(
                            color: kThemeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Spent: ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${numberFormat.format(spent)}',
                          style: TextStyle(
                            color: spent > budgetLimit
                                ? Colors.red
                                : kCurrencyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: progressBarHeight,
                width: progressBarWidth,
                decoration: BoxDecoration(
                  color: kThemeColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kRadiusCurve),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: ((progressBarHeight) * (spent / budgetLimit) >
                              progressBarHeight)
                          ? progressBarHeight
                          : (progressBarHeight) * (spent / budgetLimit),
                      decoration: BoxDecoration(
                        color: ((progressBarHeight) * (spent / budgetLimit) >
                                progressBarHeight)
                            ? Colors.red
                            : kCurrencyColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(kRadiusCurve)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double determineCardWidth(String budget) {
    if (budget.length == budgetCharLimit) {
      return 250;
    } else if (budget.length == budgetCharLimit - 1) {
      return 230;
    } else {
      return 190;
    }
  }
}
