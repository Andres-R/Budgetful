import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/number_to_month.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
    required this.description,
    required this.expenseAmount,
    required this.expenseDate,
    required this.budget,
  }) : super(key: key);

  final String description;
  final double expenseAmount;
  final String expenseDate;
  final String budget;

  String formatDate(String date) {
    List<String> splitted = date.split('-');

    String monthComponent = splitted[1];
    String dayComponent = splitted[2];

    // print('mc: $monthComponent');
    // print('dc: $dayComponent');

    String monthFormatted = "";
    String dayFormatted = "";

    if (monthComponent[0] == '0') {
      monthFormatted = numberToMonth[monthComponent[1]].toString();
    } else {
      monthFormatted = numberToMonth[monthComponent].toString();
    }

    if (dayComponent[0] == '0') {
      dayFormatted = dayComponent[1];
    } else {
      dayFormatted = dayComponent;
    }

    // print('mf: $monthFormatted');
    // print('df: $dayFormatted');

    String output = '$monthFormatted $dayFormatted';
    return output;
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return Padding(
      // adjust padding of old inner card
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: SizedBox(
        height: 55,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: 10.0),
          child: isScrollCardNeeded(description, budget, expenseAmount)
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: kCurrencyColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$description    ',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatDate(expenseDate),
                                style: TextStyle(
                                  color: kAccentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${numberFormat.format(expenseAmount)}',
                            style: TextStyle(
                              color: kCurrencyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            budget,
                            style: TextStyle(
                              color: kThemeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: kCurrencyColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: kTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatDate(expenseDate),
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${numberFormat.format(expenseAmount)}',
                          style: TextStyle(
                            color: kCurrencyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          budget,
                          style: TextStyle(
                            color: kThemeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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

  bool isScrollCardNeeded(String description, String budget, double expense) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    String formatted = numberFormat.format(expense);

    bool longDescription = false;
    bool longBudget = false;
    bool longExpense = false;

    if ((description.length == descriptionCharLimit) ||
        (description.length + 1 == descriptionCharLimit)) {
      longDescription = true;
    }
    if ((budget.length == budgetCharLimit) ||
        (budget.length + 1 == budgetCharLimit)) {
      longBudget = true;
    }
    if ((formatted.length == expenseLimit)) {
      longExpense = true;
    }
    return (longDescription && longBudget) || (longDescription && longExpense);
  }
}
