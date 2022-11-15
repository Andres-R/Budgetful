import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/expense_card_cubit.dart';
import 'package:budgetful/utils/box_decorations/create_button_box_decoration.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/number_to_month.dart';
import 'package:budgetful/utils/remove_commas.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class CreateExpenseCardScreen extends StatefulWidget {
  const CreateExpenseCardScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.budgets,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final List<Map<String, dynamic>> budgets;

  @override
  State<CreateExpenseCardScreen> createState() =>
      _CreateExpenseCardScreenState();
}

class _CreateExpenseCardScreenState extends State<CreateExpenseCardScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  final FocusNode numberFocusNode = FocusNode();

  String selectedBudget = "No budget selected";
  String selectedMonth = "No month selected";
  String selectedDay = "No day selected";

  bool useTodaysDate = true;
  bool enterDate = false;

  late List<bool> budgetOption;
  late List<bool> monthOption;
  late List<bool> dayOption;

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

  final List<int> days = List.generate(
    31,
    (index) {
      return index + 1;
    },
  );

  @override
  void initState() {
    budgetOption = List.generate(
      widget.budgets.length,
      (index) {
        return false;
      },
    );
    monthOption = List.generate(
      months.length,
      (index) {
        return false;
      },
    );
    dayOption = List.generate(
      days.length,
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

  String getBudget() {
    for (int i = 0; i < widget.budgets.length; i++) {
      if (budgetOption[i]) {
        return widget.budgets[i]['budgetName'];
      }
    }
    return 'No budget selected';
  }

  String getMonth() {
    for (int i = 0; i < months.length; i++) {
      if (monthOption[i]) {
        return months[i];
      }
    }
    return 'No month selected';
  }

  String getDay() {
    for (int i = 0; i < days.length; i++) {
      if (dayOption[i]) {
        return days[i].toString();
      }
    }
    return 'No day selected';
  }

  void createExpenseCard() {
    String description = _descriptionController.text;
    String cost = _costController.text;

    if (description.isEmpty) {
      showCustomErrorDialog(context, "Please enter an expense description");
    } else if (cost.isEmpty) {
      showCustomErrorDialog(context, "Please enter expense cost");
    } else if (cost[0] == '-') {
      showCustomErrorDialog(context, "Cost cannot be negative");
    } else if (selectedBudget == "No budget selected") {
      showCustomErrorDialog(context, "Please select a budget");
    } else if (description.length > descriptionCharLimit) {
      showCustomErrorDialog(context,
          "Description cannot exceed $descriptionCharLimit characters");
    } else if (cost.length > expenseLimit) {
      showCustomErrorDialog(context, "Expense cost cannot exceed \$999,999.99");
    } else {
      if (useTodaysDate) {
        DateTime date = DateTime.now();
        int month = date.month;
        int day = date.day;
        int year = date.year;

        String monthFormatted = month.toString().length == 1
            ? '0${month.toString()}'
            : month.toString();

        String dayFormatted =
            day.toString().length == 1 ? '0${day.toString()}' : day.toString();

        String finalDescription = description;
        double finalCost = double.parse(removeCommas(cost));
        String finalExpenseDate =
            '${year.toString()}-$monthFormatted-$dayFormatted';

        // changes expenseCardHasBeenEdited to true
        BlocProvider.of<ExpenseCardCubit>(context).addExpenseCard(
          finalDescription,
          finalCost,
          finalExpenseDate,
          selectedBudget,
          widget.userID,
          widget.screenID,
        );

        // changes expenseCardHasBeenEdited back to false
        BlocProvider.of<ExpenseCardCubit>(context).update();

        Navigator.of(context).pop();
      } else {
        if (selectedMonth == "No month selected") {
          showCustomErrorDialog(context, "Please select a month");
        } else if (selectedDay == "No day selected") {
          showCustomErrorDialog(context, "Please select a day");
        } else {
          DateTime date = DateTime.now();

          int year = date.year;

          String monthFormatted =
              monthToNumber[selectedMonth].toString().length == 1
                  ? '0${monthToNumber[selectedMonth].toString()}'
                  : monthToNumber[selectedMonth].toString();

          String dayFormatted =
              selectedDay.length == 1 ? '0$selectedDay' : selectedDay;

          String finalDescription = description;
          double finalCost = double.parse(removeCommas(cost));
          String finalExpenseDate =
              '${year.toString()}-$monthFormatted-$dayFormatted';

          // changes expenseCardHasBeenAdded to true
          BlocProvider.of<ExpenseCardCubit>(context).addExpenseCard(
            finalDescription,
            finalCost,
            finalExpenseDate,
            selectedBudget,
            widget.userID,
            widget.screenID,
          );

          // changes expenseCardHasBeenAdded back to false
          BlocProvider.of<ExpenseCardCubit>(context).update();

          Navigator.of(context).pop();
        }
      }
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
          "Create expense",
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
                            '1. Select budget category.',
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
                            '2. Select expense date.',
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
                            '3. Enter expense description.',
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
                            '4. Enter expense cost.',
                            style: TextStyle(
                              color: kThemeColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'After creating this expense, you will be able to see it in a list within your monthly expenses.',
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
                padding: EdgeInsets.symmetric(
                  horizontal: kPadding,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        widget.budgets.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (budgetOption[index]) {
                                    budgetOption[index] = false;
                                  } else {
                                    budgetOption[index] = true;
                                    for (int i = 0;
                                        i < widget.budgets.length;
                                        i++) {
                                      if (i != index) {
                                        budgetOption[i] = false;
                                      }
                                    }
                                  }
                                  selectedBudget = getBudget();
                                },
                              );
                            },
                            child: ItemOption(
                              title: widget.budgets[index]['budgetName'],
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
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!useTodaysDate) {
                              useTodaysDate = !useTodaysDate;
                              enterDate = false;
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: useTodaysDate
                                ? kDarkBGColor.withOpacity(0.5)
                                : kDarkBGColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(kRadiusCurve),
                            ),
                            border: Border.all(
                              color: useTodaysDate
                                  ? kCurrencyColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Today\'s date',
                              style: TextStyle(
                                color: kCurrencyColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: kPadding),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!enterDate) {
                              enterDate = !enterDate;
                              useTodaysDate = false;
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: enterDate
                                ? kDarkBGColor.withOpacity(0.5)
                                : kDarkBGColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(kRadiusCurve),
                            ),
                            border: Border.all(
                              color: enterDate
                                  ? kCurrencyColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Enter date',
                              style: TextStyle(
                                color: kCurrencyColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              enterDate
                  ? Padding(
                      padding:
                          EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 0),
                      child: Center(
                        child: Text(
                          'Please select month and day',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: enterDate
                    ? EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 0)
                    : const EdgeInsets.all(0),
                child: Container(
                  color: kMainBGColor,
                  child: enterDate
                      ? Column(
                          children: [
                            SingleChildScrollView(
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
                                              if (monthOption[index]) {
                                                monthOption[index] = false;
                                              } else {
                                                monthOption[index] = true;
                                                for (int i = 0;
                                                    i < months.length;
                                                    i++) {
                                                  if (i != index) {
                                                    monthOption[i] = false;
                                                  }
                                                }
                                              }
                                              selectedMonth = getMonth();
                                            },
                                          );
                                        },
                                        child: ItemOption(
                                          title: months[index],
                                          hasBeenPressed:
                                              monthOption[index] ? true : false,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                    days.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              if (dayOption[index]) {
                                                dayOption[index] = false;
                                              } else {
                                                dayOption[index] = true;
                                                for (int i = 0;
                                                    i < days.length;
                                                    i++) {
                                                  if (i != index) {
                                                    dayOption[i] = false;
                                                  }
                                                }
                                              }
                                              selectedDay = getDay();
                                            },
                                          );
                                        },
                                        child: NumberOption(
                                          number: days[index].toString(),
                                          hasBeenPressed:
                                              dayOption[index] ? true : false,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _descriptionController,
                  hint: "Enter expense description",
                  icon: Icons.text_snippet,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _costController,
                  hint: "Enter expense cost",
                  icon: Icons.money,
                  obscureText: false,
                  inputType: const TextInputType.numberWithOptions(),
                  enableCurrencyMode: true,
                  next: false,
                  focusNode: numberFocusNode,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: createExpenseCard,
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

class ItemOption extends StatelessWidget {
  const ItemOption({
    Key? key,
    required this.title,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String title;
  final bool hasBeenPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding / 2.0,
        vertical: kPadding,
      ),
      child: Container(
        height: 50,
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
            horizontal: kPadding * 2,
            vertical: kPadding / 2.0,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: kCurrencyColor,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberOption extends StatelessWidget {
  const NumberOption({
    Key? key,
    required this.number,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String number;
  final bool hasBeenPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding / 2.0,
        vertical: kPadding,
      ),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: hasBeenPressed ? kDarkBGColor.withOpacity(0.5) : kDarkBGColor,
          border: Border.all(
            color: hasBeenPressed ? kCurrencyColor : Colors.transparent,
            width: 1,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: kCurrencyColor,
              fontSize: kPadding,
            ),
          ),
        ),
      ),
    );
  }
}
