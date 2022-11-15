import 'package:budgetful/cubit/budget_card_cubit.dart';
import 'package:budgetful/screens/budgeting/cards/budget_card.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/remove_commas.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditBudgetCardScreen extends StatefulWidget {
  const EditBudgetCardScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.budgetCards,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final List<Map<String, dynamic>> budgetCards;

  @override
  State<EditBudgetCardScreen> createState() => _EditBudgetCardScreenState();
}

class _EditBudgetCardScreenState extends State<EditBudgetCardScreen> {
  final TextEditingController _addLimitController = TextEditingController();

  final FocusNode numberFocusNode = FocusNode();

  int selectedBudgetCardID = -1;
  double amountToBeAdded = 0.0;
  late List<bool> cardOption;

  @override
  void initState() {
    cardOption = List.generate(
      widget.budgetCards.length,
      (index) {
        return false;
      },
    );
    numberFocusNode.addListener(
      () {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    numberFocusNode.dispose();
    super.dispose();
  }

  int getBudgetCardID() {
    for (int i = 0; i < widget.budgetCards.length; i++) {
      if (cardOption[i]) {
        return widget.budgetCards[i]['budgetCardID'];
      }
    }
    return -1;
  }

  double getBudgetLimit() {
    for (int i = 0; i < widget.budgetCards.length; i++) {
      if (cardOption[i]) {
        return widget.budgetCards[i]['budgetLimit'].toDouble();
      }
    }
    return -1.0;
  }

  String getBudgetName() {
    for (int i = 0; i < widget.budgetCards.length; i++) {
      if (cardOption[i]) {
        return widget.budgetCards[i]['budgetName'];
      }
    }
    return '-1.0';
  }

  double getBudgetSpent() {
    for (int i = 0; i < widget.budgetCards.length; i++) {
      if (cardOption[i]) {
        return widget.budgetCards[i]['spent'].toDouble();
      }
    }
    return -1.0;
  }

  void updateBudgetLimitCard() {
    int finalCardID = selectedBudgetCardID;
    double finalAmount = amountToBeAdded + getBudgetLimit();

    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    String totalAmount = numberFormat.format(finalAmount);

    if (finalCardID == -1) {
      showCustomErrorDialog(context, "Please choose a budget to update");
    } else if (amountToBeAdded == 0.0) {
      showCustomErrorDialog(
          context, "Please enter and confirm an amount to add to limit");
    } else if (amountToBeAdded < 0) {
      showCustomErrorDialog(
          context, "Amount to add to limit cannot be negative");
    } else if (totalAmount.length > budgetLimit) {
      showCustomErrorDialog(context, "Budget limit cannot exceed \$999,999.99");
    } else {
      BlocProvider.of<BudgetCardCubit>(context).updateBudgetLimit(
          finalAmount, finalCardID, widget.userID, widget.screenID);

      BlocProvider.of<BudgetCardCubit>(context).updateBudgetCards();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: true,
        title: Text(
          "Edit budget card",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        color: kMainBGColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Center(
                  child: Text(
                    'Select budget card to increase limit.',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding / 2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        widget.budgetCards.length,
                        (index) {
                          Map<String, dynamic> cardInfo =
                              widget.budgetCards[index];
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (cardOption[index]) {
                                    cardOption[index] = false;
                                  } else {
                                    cardOption[index] = true;
                                    for (int i = 0;
                                        i < widget.budgetCards.length;
                                        i++) {
                                      if (i != index) {
                                        cardOption[i] = false;
                                      }
                                    }
                                  }
                                  selectedBudgetCardID = getBudgetCardID();
                                },
                              );
                            },
                            child: BudgetCardOption(
                              budget: cardInfo['budgetName'],
                              budgetLimit: cardInfo['budgetLimit'].toDouble(),
                              spent: cardInfo['spent'].toDouble(),
                              hasBeenPressed: cardOption[index] ? true : false,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  kPadding,
                  kPadding,
                  kPadding,
                  kPadding / 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current limit for selected budget: ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      selectedBudgetCardID == -1
                          ? '\$0.00'
                          : '\$${numberFormat.format(getBudgetLimit())}',
                      style: TextStyle(
                        color: kCurrencyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _addLimitController,
                  hint: "Enter amount to add to limit",
                  icon: Icons.money,
                  obscureText: false,
                  inputType: TextInputType.number,
                  enableCurrencyMode: true,
                  next: false,
                  focusNode: numberFocusNode,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        amountToBeAdded = double.parse(
                          removeCommas(_addLimitController.text),
                        );
                      },
                    );
                  },
                  child: const ConfirmButtonDecoration(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  kPadding,
                  kPadding / 2.0,
                  kPadding,
                  kPadding / 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Amount to be added to limit: ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      '\$${numberFormat.format(amountToBeAdded)}',
                      style: TextStyle(
                        color: kCurrencyColor,
                      ),
                    ),
                  ],
                ),
              ),
              (amountToBeAdded != 0 &&
                      selectedBudgetCardID != -1 &&
                      amountToBeAdded > 0 &&
                      numberFormat.format(amountToBeAdded).length < budgetLimit)
                  ? BudgetCard(
                      budget: getBudgetName(),
                      budgetLimit: getBudgetLimit() + amountToBeAdded,
                      spent: getBudgetSpent())
                  : Container(),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateBudgetLimitCard,
                  child: const UpdateButtonDecoration(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetCardOption extends StatefulWidget {
  const BudgetCardOption({
    Key? key,
    required this.budget,
    required this.budgetLimit,
    required this.spent,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String budget;
  final double budgetLimit;
  final double spent;
  final bool hasBeenPressed;

  @override
  State<BudgetCardOption> createState() => _BudgetCardOptionState();
}

class _BudgetCardOptionState extends State<BudgetCardOption> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    double cardHeight = 150;
    double cardWidth = determineCardWidth(widget.budget); // original 170
    double progressBarHeight = 100;
    double progressBarWidth = 10;

    return Padding(
      padding: EdgeInsets.all(kPadding / 2),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          color: widget.hasBeenPressed
              ? kTextColor.withOpacity(0.2)
              : kDarkBGColor,
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
                    widget.budget,
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
                          text: '\$${numberFormat.format(widget.budgetLimit)}',
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
                          text: '\$${numberFormat.format(widget.spent)}',
                          style: TextStyle(
                            color: widget.spent > widget.budgetLimit
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
                      height: ((progressBarHeight) *
                                  (widget.spent / widget.budgetLimit) >
                              progressBarHeight)
                          ? progressBarHeight
                          : (progressBarHeight) *
                              (widget.spent / widget.budgetLimit),
                      decoration: BoxDecoration(
                        color: ((progressBarHeight) *
                                    (widget.spent / widget.budgetLimit) >
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

class UpdateButtonDecoration extends StatelessWidget {
  const UpdateButtonDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Update",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}

class ConfirmButtonDecoration extends StatelessWidget {
  const ConfirmButtonDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(kRadiusCurve),
        ),
        color: kThemeColor,
      ),
      child: Center(
        child: Text(
          'Confirm amount to add',
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
