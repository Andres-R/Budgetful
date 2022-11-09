import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/screen_total_budget_limit_cubit.dart';
import 'package:budgetful/cubit/screen_total_spent_cubit.dart';
import 'package:budgetful/screens/budgeting/cards/budget_card.dart';
import 'package:budgetful/screens/budgeting/cards/expense_card.dart';
import 'package:budgetful/screens/budgeting/create%20screens/create_budget_card_screen.dart';
import 'package:budgetful/screens/budgeting/create%20screens/create_expense_card_screen.dart';
import 'package:budgetful/screens/budgeting/filter_screen.dart';
import 'package:budgetful/utils/box_decorations/add_button_box_decoration.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/section_title.dart';
import 'package:intl/intl.dart';
import 'package:budgetful/cubit/budget_card_cubit.dart';
import 'package:budgetful/cubit/expense_card_cubit.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  const MonthlyExpenseScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.cardMonth,
    required this.cardYear,
    required this.checkAmount,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final String cardMonth;
  final int cardYear;
  final double checkAmount;

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  late BudgetCardCubit _budgetCardCubit;
  late ExpenseCardCubit _expenseCardCubit;
  late ScreenTotalSpentCubit _totalSpentCubit;
  late ScreenTotalBudgetLimitCubit _totalBudgetLimitCubit;

  @override
  void initState() {
    _budgetCardCubit =
        BudgetCardCubit(userID: widget.userID, screenID: widget.screenID);
    _expenseCardCubit =
        ExpenseCardCubit(userID: widget.userID, screenID: widget.screenID);
    _totalSpentCubit =
        ScreenTotalSpentCubit(userID: widget.userID, screenID: widget.screenID);
    _totalBudgetLimitCubit = ScreenTotalBudgetLimitCubit(
        userID: widget.userID, screenID: widget.screenID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // values to customize summary card section
    double cardheight = 80;
    double innerPadding = 0.0;
    double labelSize = 22;
    double valueSize = 16;

    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return MultiBlocProvider(
      providers: [
        BlocProvider<BudgetCardCubit>(
          create: (context) => _budgetCardCubit,
        ),
        BlocProvider<ExpenseCardCubit>(
          create: (context) => _expenseCardCubit,
        ),
        BlocProvider<ScreenTotalSpentCubit>(
          create: (context) => _totalSpentCubit,
        ),
        BlocProvider<ScreenTotalBudgetLimitCubit>(
          create: (context) => _totalBudgetLimitCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: kTextColor,
          ),
          title: Column(
            children: [
              Text(
                "Monthly Expenses",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 20,
                ),
              ),
              Text(
                widget.cardMonth,
                style: TextStyle(
                  color: kThemeColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: kMainBGColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Container(
                    //  height: 150,
                    decoration: BoxDecoration(
                      color: kDarkBGColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(kRadiusCurve),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(innerPadding),
                                child: SizedBox(
                                  height: cardheight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Check',
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: labelSize,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '\$${numberFormat.format(widget.checkAmount)}',
                                        style: TextStyle(
                                          color: kCurrencyColor,
                                          fontSize: valueSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(innerPadding),
                                child: SizedBox(
                                  height: cardheight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Limit',
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: labelSize,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      BlocBuilder<ScreenTotalBudgetLimitCubit,
                                          ScreenTotalBudgetLimitState>(
                                        builder: (_, totalBudgetLimitState) {
                                          return BlocConsumer<BudgetCardCubit,
                                              BudgetCardState>(
                                            listener: (_, state) {
                                              if (state
                                                  .budgetCardHasBeenAdded) {
                                                _totalBudgetLimitCubit
                                                    .updateTotalBudgetLimit();
                                              }
                                            },
                                            builder: (_, state) {
                                              return Text(
                                                '\$${numberFormat.format(totalBudgetLimitState.totalBudgetLimit)}',
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: valueSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(innerPadding),
                                child: SizedBox(
                                  height: cardheight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Saved',
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: labelSize,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      BlocBuilder<ScreenTotalSpentCubit,
                                          ScreenTotalSpentState>(
                                        builder: (_, totalSpentState) {
                                          return BlocConsumer<ExpenseCardCubit,
                                              ExpenseCardState>(
                                            listener: (_, state) {
                                              if (state
                                                  .expenseCardHasBeenAdded) {
                                                _totalSpentCubit
                                                    .updateTotalSpent();
                                              }
                                            },
                                            builder: (_, state) {
                                              double totalSaved = widget
                                                      .checkAmount -
                                                  totalSpentState.totalSpent;
                                              return Text(
                                                '\$${numberFormat.format(totalSaved)}',
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: valueSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(innerPadding),
                                child: SizedBox(
                                  height: cardheight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Spent',
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: labelSize,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      BlocBuilder<ScreenTotalSpentCubit,
                                          ScreenTotalSpentState>(
                                        builder: (_, totalSpentState) {
                                          return BlocConsumer<ExpenseCardCubit,
                                              ExpenseCardState>(
                                            listener: (_, state) {
                                              if (state
                                                  .expenseCardHasBeenAdded) {
                                                _totalSpentCubit
                                                    .updateTotalSpent();
                                              }
                                            },
                                            builder: (_, state) {
                                              return Text(
                                                '\$${numberFormat.format(totalSpentState.totalSpent)}',
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: valueSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle(title: "Budgets"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return BlocProvider.value(
                                  value: _budgetCardCubit,
                                  child: CreateBudgetCardScreen(
                                    userID: widget.userID,
                                    screenID: widget.screenID,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: const AddButtonBoxDecoration(
                          label: "Add Budget",
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<BudgetCardCubit, BudgetCardState>(
                  builder: (_, budgetCardState) {
                    return BlocConsumer<ExpenseCardCubit, ExpenseCardState>(
                      listener: (_, state) {
                        if (state.expenseCardHasBeenAdded) {
                          _budgetCardCubit.updateBudgetCards();
                        }
                      },
                      builder: (_, state) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: kPadding / 2.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  budgetCardState.budgetCards.length,
                                  (index) {
                                    Map<String, dynamic> cardInfo =
                                        budgetCardState.budgetCards[index];
                                    return BudgetCard(
                                      budget: cardInfo['budgetName'],
                                      budgetLimit:
                                          cardInfo['budgetLimit'].toDouble(),
                                      spent: cardInfo['spent'].toDouble(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // This BlocBuilder may be unnecessary and may affect performance
                // but is implemented like other BlocBuilders so logically valid
                BlocBuilder<BudgetCardCubit, BudgetCardState>(
                  builder: (_, state) {
                    return Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SectionTitle(title: "Expenses"),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (state.budgetCards.isEmpty) {
                                    showCustomErrorDialog(context,
                                        "Must create a budget before filtering expenses!");
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return FilterScreen(
                                            userID: widget.userID,
                                            screenID: widget.screenID,
                                            budgets: state.budgetCards,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'filter',
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.budgetCards.isEmpty) {
                                showCustomErrorDialog(context,
                                    "Must create a budget before adding an expense!");
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: _expenseCardCubit,
                                        child: CreateExpenseCardScreen(
                                          userID: widget.userID,
                                          screenID: widget.screenID,
                                          budgets: state.budgetCards,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            child: const AddButtonBoxDecoration(
                              label: "Add Expense",
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<ExpenseCardCubit, ExpenseCardState>(
                  builder: (_, state) {
                    return Padding(
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
                              state.expenseCards.length,
                              (index) {
                                bool displayDivider =
                                    (index == state.expenseCards.length - 1)
                                        ? false
                                        : true;

                                Map<String, dynamic> cardInfo =
                                    state.expenseCards[index];
                                return Column(
                                  children: [
                                    ExpenseCard(
                                      description:
                                          cardInfo['expenseDescription'],
                                      expenseAmount:
                                          cardInfo['expenseAmount'].toDouble(),
                                      expenseDate: cardInfo['expenseDate'],
                                      budget: cardInfo['budget'],
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
