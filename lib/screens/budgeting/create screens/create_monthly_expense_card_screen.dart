import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/monthly_expense_card_cubit.dart';
import 'package:budgetful/utils/box_decorations/create_button_box_decoration.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/remove_commas.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';

class CreateMonthlyExpenseCardScreen extends StatefulWidget {
  const CreateMonthlyExpenseCardScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<CreateMonthlyExpenseCardScreen> createState() =>
      _CreateMonthlyExpenseCardScreenState();
}

class _CreateMonthlyExpenseCardScreenState
    extends State<CreateMonthlyExpenseCardScreen> {
  final TextEditingController _checkAmountController = TextEditingController();

  String selectedMonth = "No month selected";

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  late List<bool> budgetOption;

  @override
  void initState() {
    budgetOption = List.generate(
      months.length,
      (index) {
        return false;
      },
    );
    super.initState();
  }

  String getMonth() {
    for (int i = 0; i < months.length; i++) {
      if (budgetOption[i]) {
        return months[i];
      }
    }
    return "No month selected";
  }

  void createMonthlyExpenseCard() {
    // String month = _monthController.text;
    String checkAmount = _checkAmountController.text;

    if (selectedMonth == "No month selected") {
      showCustomErrorDialog(context, "Please select month");
    } else if (checkAmount.isEmpty) {
      showCustomErrorDialog(context, "Please enter check amount");
    } else if (checkAmount[0] == '-') {
      showCustomErrorDialog(context, "Check amount cannot be negative");
    } else if (checkAmount.length > monthCheckLimit) {
      showCustomErrorDialog(context, "Check amount cannot exceed \$999,999.99");
    } else {
      //String cardMonth = capitalizeFirstLetter(month);
      double cardCheck = double.parse(removeCommas(checkAmount));
      int cardYear = int.parse(DateTime.now().year.toString());

      BlocProvider.of<MonthlyExpenseCardCubit>(context).addMonthlyExpenseCard(
          selectedMonth, cardYear, cardCheck, widget.userID);

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
          "Create month card",
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
          physics: const ClampingScrollPhysics(),
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
                            '1. Select a month.',
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
                            '2. Enter amount earned for that month.',
                            style: TextStyle(
                              color: kThemeColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'After creating this month card, you will be able to add budgets and expenses to this month to keep track of spending.',
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
                padding: EdgeInsets.symmetric(horizontal: kPadding / 2),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        months.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (budgetOption[index]) {
                                    budgetOption[index] = false;
                                  } else {
                                    budgetOption[index] = true;
                                    for (int i = 0; i < months.length; i++) {
                                      if (i != index) {
                                        budgetOption[i] = false;
                                      }
                                    }
                                  }
                                  selectedMonth = getMonth();
                                },
                              );
                            },
                            child: MonthOption(
                              month: months[index],
                              hasBeenPressed:
                                  budgetOption[index] ? true : false,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _checkAmountController,
                  hint: "Enter check amount",
                  icon: Icons.money,
                  obscureText: false,
                  inputType: const TextInputType.numberWithOptions(),
                  enableCurrencyMode: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: createMonthlyExpenseCard,
                  child: const CreateButtonBoxDecoration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthOption extends StatelessWidget {
  const MonthOption({
    Key? key,
    required this.month,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String month;
  final bool hasBeenPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding / 2.0,
        vertical: kPadding,
      ),
      child: Container(
        //height: optionHeight,
        decoration: BoxDecoration(
          color: hasBeenPressed ? kDarkBGColor.withOpacity(0.5) : kDarkBGColor,
          borderRadius: BorderRadius.all(
            Radius.circular(kRadiusCurve),
          ),
          border: Border.all(
            color: hasBeenPressed ? kCurrencyColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kPadding,
            vertical: kPadding / 2.0,
          ),
          child: Text(
            month,
            style: TextStyle(
              color: kCurrencyColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
