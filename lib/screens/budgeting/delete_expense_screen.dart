import 'package:budgetful/cubit/expense_card_cubit.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/number_to_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DeleteExpenseScreen extends StatefulWidget {
  const DeleteExpenseScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.expenses,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final List<Map<String, dynamic>> expenses;

  @override
  State<DeleteExpenseScreen> createState() => _DeleteExpenseScreenState();
}

class _DeleteExpenseScreenState extends State<DeleteExpenseScreen> {
  int selectedCardID = -1;
  String selectedBudget = "No Budget Selected";
  late List<bool> cardOption;

  @override
  void initState() {
    super.initState();
    cardOption = List.generate(
      widget.expenses.length,
      (index) {
        return false;
      },
    );
  }

  int getSelectedCardID() {
    for (int i = 0; i < widget.expenses.length; i++) {
      if (cardOption[i]) {
        return widget.expenses[i]['expenseCardID'];
      }
    }
    return -1;
  }

  String getBudget() {
    for (int i = 0; i < widget.expenses.length; i++) {
      if (cardOption[i]) {
        return widget.expenses[i]['budget'];
      }
    }
    return "No Budget Selected";
  }

  void deleteExpenseCard() {
    if (selectedCardID == -1) {
      showCustomErrorDialog(context, "Please select an expense to delete");
    } else {
      BlocProvider.of<ExpenseCardCubit>(context).deleteExpenseCard(
        selectedCardID,
        selectedBudget,
        widget.userID,
        widget.screenID,
      );
      BlocProvider.of<ExpenseCardCubit>(context).update();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Delete expense",
          style: TextStyle(
            color: kTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kMainBGColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: SizedBox(
                  //height: 150,
                  //color: kDarkBGColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '1. Select expense to delete.',
                            style: TextStyle(
                              color: kThemeColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '2. Confirm.',
                            style: TextStyle(
                              color: kThemeColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'After deleting expense, it will be removed from your expenses list.',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Container(
                  decoration: BoxDecoration(
                    color: kDarkBGColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(kRadiusCurve)),
                  ),
                  child: Column(
                    children: [
                      ...List.generate(
                        widget.expenses.length,
                        (index) {
                          bool displayDivider =
                              (index == widget.expenses.length - 1)
                                  ? false
                                  : true;

                          Map<String, dynamic> cardInfo =
                              widget.expenses[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      if (cardOption[index]) {
                                        cardOption[index] = false;
                                      } else {
                                        cardOption[index] = true;
                                        for (int i = 0;
                                            i < widget.expenses.length;
                                            i++) {
                                          if (i != index) {
                                            cardOption[i] = false;
                                          }
                                        }
                                      }
                                      selectedCardID = getSelectedCardID();
                                      selectedBudget = getBudget();
                                    },
                                  );
                                },
                                child: DeleteExpenseCard(
                                  description: cardInfo['expenseDescription'],
                                  expenseAmount:
                                      cardInfo['expenseAmount'].toDouble(),
                                  expenseDate: cardInfo['expenseDate'],
                                  budget: cardInfo['budget'],
                                  hasBeenPressed:
                                      cardOption[index] ? true : false,
                                ),
                              ),
                              displayDivider
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        left: kPadding,
                                      ),
                                      child: Divider(
                                        color: Colors.grey.shade800,
                                        height: 0,
                                        thickness: 1,
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: deleteExpenseCard,
                  child: const DeleteButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Center(
        child: Text(
          'Delete',
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class DeleteExpenseCard extends StatefulWidget {
  const DeleteExpenseCard({
    Key? key,
    required this.description,
    required this.expenseAmount,
    required this.expenseDate,
    required this.budget,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String description;
  final double expenseAmount;
  final String expenseDate;
  final String budget;
  final bool hasBeenPressed;

  @override
  State<DeleteExpenseCard> createState() => _DeleteExpenseCardState();
}

class _DeleteExpenseCardState extends State<DeleteExpenseCard> {
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
          child: isScrollCardNeeded(
                  widget.description, widget.budget, widget.expenseAmount)
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
                              color: widget.hasBeenPressed
                                  ? kCurrencyColor
                                  : kDarkBGColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.hasBeenPressed
                                    ? kCurrencyColor
                                    : kAccentColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: widget.hasBeenPressed
                                  ? Icon(
                                      Icons.check,
                                      color: kTextColor,
                                    )
                                  : Container(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.description}    ',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatDate(widget.expenseDate),
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
                            '\$${numberFormat.format(widget.expenseAmount)}',
                            style: TextStyle(
                              color: kCurrencyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.budget,
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
                            color: widget.hasBeenPressed
                                ? kCurrencyColor
                                : kDarkBGColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.hasBeenPressed
                                  ? kCurrencyColor
                                  : kAccentColor,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: widget.hasBeenPressed
                                ? Icon(
                                    Icons.check,
                                    color: kTextColor,
                                  )
                                : Container(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.description,
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatDate(widget.expenseDate),
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
                    Expanded(
                      child: Container(
                        height: 35,
                        color: kDarkBGColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${numberFormat.format(widget.expenseAmount)}',
                          style: TextStyle(
                            color: kCurrencyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.budget,
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
