import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:intl/intl.dart';

class AdvancedStatCard extends StatelessWidget {
  const AdvancedStatCard({
    Key? key,
    required this.spent,
    required this.check,
    required this.month,
    required this.year,
    required this.budgets,
  }) : super(key: key);

  final double spent;
  final double check;
  final String month;
  final int year;
  final List<Map<String, dynamic>> budgets;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    double progressBarHeight = 100;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: kPadding / 2.0,
        horizontal: kPadding,
      ),
      child: Container(
        //height: 150,
        decoration: BoxDecoration(
          color: kDarkBGColor,
          borderRadius: BorderRadius.all(
            Radius.circular(kRadiusCurve),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$month ${year.toString()}',
                    style: TextStyle(
                      color: kThemeColor,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Check:',
                        style: TextStyle(
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '\$${numberFormat.format(check)}',
                        style: TextStyle(
                          color: kCurrencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Spent:',
                        style: TextStyle(
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '\$${numberFormat.format(spent)}',
                        style: TextStyle(
                          color: spent > check ? Colors.red : kCurrencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 32),
                  // Text(
                  //   'Budget expenditures',
                  //   style: TextStyle(
                  //     color: kThemeColor,
                  //     fontSize: 16,
                  //   ),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        budgets.length,
                        (index) {
                          Map<String, dynamic> budgetInfo = budgets[index];
                          return isBudgetLong(budgetInfo['budgetName'])
                              ? SizedBox(
                                  width: 140,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Swipe text left <- ',
                                          style: TextStyle(
                                            color: kAccentColor,
                                          ),
                                        ),
                                        Text(
                                          budgetInfo['budgetName'],
                                          style: TextStyle(
                                            color: kTextColor,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '\$${numberFormat.format(budgetInfo['spent'])}',
                                          style: TextStyle(
                                            color: kCurrencyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      budgetInfo['budgetName'],
                                      style: TextStyle(
                                        color: kTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '\$${numberFormat.format(budgetInfo['spent'])}',
                                      style: TextStyle(
                                        color: kCurrencyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              check == 0.0
                  ? Container()
                  : Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${((spent / check) * 100.0).toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: ((progressBarHeight) * (spent / check) >
                                        progressBarHeight)
                                    ? Colors.red
                                    : kCurrencyColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 75,
                              child: Text(
                                'of your check for this month was spent',
                                style: TextStyle(
                                  color: kTextColor,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Container(
                          height: progressBarHeight,
                          width: 10,
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
                                height: ((progressBarHeight) * (spent / check) >
                                        progressBarHeight)
                                    ? progressBarHeight
                                    : (progressBarHeight) * (spent / check),
                                decoration: BoxDecoration(
                                  color:
                                      ((progressBarHeight) * (spent / check) >
                                              progressBarHeight)
                                          ? Colors.red
                                          : kCurrencyColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(kRadiusCurve)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isBudgetLong(String budget) {
  if ((budget.length == budgetCharLimit) ||
      ((budget.length + 1) == budgetCharLimit)) {
    return true;
  }
  return false;
}
