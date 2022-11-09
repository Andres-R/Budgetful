import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/monthly_expense_card_cubit.dart';
import 'package:budgetful/screens/budgeting/cards/monthly_expense_card.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/remove_commas.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
import 'package:intl/intl.dart';

class EditMonthlyExpenseCardScreen extends StatefulWidget {
  const EditMonthlyExpenseCardScreen({
    Key? key,
    required this.userID,
    required this.monthlyExpenseCards,
  }) : super(key: key);

  final int userID;
  final List<Map<String, dynamic>> monthlyExpenseCards;

  @override
  State<EditMonthlyExpenseCardScreen> createState() =>
      _EditMonthlyExpenseCardScreenState();
}

class _EditMonthlyExpenseCardScreenState
    extends State<EditMonthlyExpenseCardScreen> {
  final TextEditingController _addCheckController = TextEditingController();

  int selectedMonthCardID = -1;
  double amountToBeAdded = 0.0;
  late List<bool> cardOption;

  @override
  void initState() {
    cardOption = List.generate(
      widget.monthlyExpenseCards.length,
      (index) {
        return false;
      },
    );
    super.initState();
  }

  int getMonthCardID() {
    for (int i = 0; i < widget.monthlyExpenseCards.length; i++) {
      if (cardOption[i]) {
        return widget.monthlyExpenseCards[i]['cardID'];
      }
    }
    return -1;
  }

  String getCardMonth() {
    for (int i = 0; i < widget.monthlyExpenseCards.length; i++) {
      if (cardOption[i]) {
        return '${widget.monthlyExpenseCards[i]['cardMonth']}';
      }
    }
    return '-1';
  }

  String getCardYear() {
    for (int i = 0; i < widget.monthlyExpenseCards.length; i++) {
      if (cardOption[i]) {
        return '${widget.monthlyExpenseCards[i]['cardYear']}';
      }
    }
    return '-1';
  }

  double getCardIncome() {
    for (int i = 0; i < widget.monthlyExpenseCards.length; i++) {
      if (cardOption[i]) {
        return widget.monthlyExpenseCards[i]['checkAmount'].toDouble();
      }
    }
    return -1.0;
  }

  void updateMonthlyExpenseCard() {
    int finalCardID = selectedMonthCardID;
    double finalAmount = amountToBeAdded + getCardIncome();

    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    String totalAmount = numberFormat.format(finalAmount);

    if (selectedMonthCardID == -1) {
      showCustomErrorDialog(context, "Please choose a month to update");
    } else if (amountToBeAdded == 0.0) {
      showCustomErrorDialog(
          context, "Please enter and confirm an amount to add to month");
    } else if (amountToBeAdded < 0) {
      showCustomErrorDialog(
          context, "Amount to add to month cannot be negative");
    } else if (totalAmount.length > monthCheckLimit) {
      showCustomErrorDialog(context, "Month income cannot exceed \$999,999.99");
    } else {
      BlocProvider.of<MonthlyExpenseCardCubit>(context)
          .updateMonthlyExpenseCardIncome(
              finalCardID, finalAmount, widget.userID);

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
          "Edit month card",
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
                    'Select month card to add additional income.',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 235,
                child: ListView.builder(
                  itemCount: widget.monthlyExpenseCards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            if (cardOption[index]) {
                              cardOption[index] = false;
                            } else {
                              cardOption[index] = true;
                              for (int i = 0;
                                  i < widget.monthlyExpenseCards.length;
                                  i++) {
                                if (i != index) {
                                  cardOption[i] = false;
                                }
                              }
                            }
                            selectedMonthCardID = getMonthCardID();
                          },
                        );
                      },
                      child: MonthlyExpenseCardOption(
                        cardMonth: widget.monthlyExpenseCards[index]
                            ['cardMonth'],
                        cardYear: widget.monthlyExpenseCards[index]['cardYear'],
                        checkAmount: widget.monthlyExpenseCards[index]
                                ['checkAmount']
                            .toDouble(),
                        hasBeenPressed: cardOption[index] ? true : false,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  kPadding,
                  kPadding,
                  kPadding,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedMonthCardID == -1
                          ? 'Choose card'
                          : getCardMonth(),
                      style: TextStyle(
                        color: kThemeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      selectedMonthCardID == -1 ? '' : getCardYear(),
                      style: TextStyle(
                        color: kThemeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                      'Current income for selected month: ',
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      selectedMonthCardID == -1
                          ? '\$0.00'
                          : '\$${numberFormat.format(getCardIncome())}',
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
                  controller: _addCheckController,
                  hint: "Enter amount to add to month",
                  icon: Icons.money,
                  obscureText: false,
                  inputType: const TextInputType.numberWithOptions(),
                  enableCurrencyMode: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      amountToBeAdded = double.parse(
                        removeCommas(_addCheckController.text),
                      );
                    });
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
                      'Amount to be added to check: ',
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
              (amountToBeAdded != 0 && selectedMonthCardID != -1)
                  ? MonthlyExpenseCard(
                      cardMonth: getCardMonth(),
                      cardYear: int.parse(getCardYear()),
                      checkAmount: getCardIncome() + amountToBeAdded)
                  : Container(),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateMonthlyExpenseCard,
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

class MonthlyExpenseCardOption extends StatefulWidget {
  const MonthlyExpenseCardOption({
    Key? key,
    required this.cardMonth,
    required this.cardYear,
    required this.checkAmount,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String cardMonth;
  final int cardYear;
  final double checkAmount;
  final bool hasBeenPressed;

  @override
  State<MonthlyExpenseCardOption> createState() =>
      _MonthlyExpenseCardOptionState();
}

class _MonthlyExpenseCardOptionState extends State<MonthlyExpenseCardOption> {
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
          color: widget.hasBeenPressed
              ? kTextColor.withOpacity(0.2)
              : kDarkBGColor,
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
                    widget.cardMonth,
                    style: TextStyle(
                      color: kThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.cardYear.toString(),
                    style: TextStyle(
                      color: kAccentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "\$${numberFormat.format(widget.checkAmount)}",
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
