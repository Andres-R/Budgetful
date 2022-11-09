import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/expense_card_cubit.dart';
import 'package:budgetful/screens/budgeting/cards/expense_card.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.budgets,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final List<Map<String, dynamic>> budgets;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late ExpenseCardCubit _expenseCardCubit;

  String selectedBudget = "Select budget";

  late List<bool> budgetOption;

  @override
  void initState() {
    _expenseCardCubit =
        ExpenseCardCubit(userID: widget.userID, screenID: widget.screenID);
    budgetOption = List.generate(
      widget.budgets.length,
      (index) {
        return false;
      },
    );
    super.initState();
  }

  int getIndexForTotalSpent() {
    for (int i = 0; i < widget.budgets.length; i++) {
      if (budgetOption[i]) {
        return i;
      }
    }
    return 0;
  }

  String getBudget() {
    for (int i = 0; i < widget.budgets.length; i++) {
      if (budgetOption[i]) {
        return widget.budgets[i]['budgetName'];
      }
    }
    return 'Select budget';
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return BlocProvider<ExpenseCardCubit>(
      create: (context) => _expenseCardCubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: kTextColor,
          ),
          title: Text(
            'Filter Expenses',
            style: TextStyle(
              color: kTextColor,
              fontSize: 22,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: kMainBGColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kPadding / 2.0),
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

                                    if (selectedBudget == "Select budget") {
                                      _expenseCardCubit.update();
                                    } else {
                                      _expenseCardCubit.filterByBudget(
                                        widget.userID,
                                        widget.screenID,
                                        selectedBudget,
                                      );
                                    }
                                  },
                                );
                              },
                              child: BudgetOption(
                                name: widget.budgets[index]['budgetName'],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedBudget,
                        style: TextStyle(
                          color: kThemeColor,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            (getBudget() == "Select budget")
                                ? '\$0.00'
                                : '\$${numberFormat.format(widget.budgets[getIndexForTotalSpent()]['spent'])}',
                            style: TextStyle(
                              color: kCurrencyColor,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

class BudgetOption extends StatelessWidget {
  const BudgetOption({
    Key? key,
    required this.name,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String name;
  final bool hasBeenPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding / 2.0,
        vertical: kPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: hasBeenPressed ? kThemeColor.withOpacity(0.5) : kThemeColor,
          borderRadius: BorderRadius.all(
            Radius.circular(kRadiusCurve),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kPadding,
            vertical: kPadding / 2.0,
          ),
          child: Text(
            name,
            style: TextStyle(
              color: kTextColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// v v THIS IS THE OLD FORMAT FOR BUDGET FILTER v v

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:budgetful/cubit/expense_card_cubit.dart';
// import 'package:budgetful/screens/budgeting/cards/expense_card.dart';
// import 'package:budgetful/utils/constants.dart';
// import 'package:intl/intl.dart';

// class FilterScreen extends StatefulWidget {
//   const FilterScreen({
//     Key? key,
//     required this.userID,
//     required this.screenID,
//     required this.budgets,
//   }) : super(key: key);

//   final int userID;
//   final int screenID;
//   final List<Map<String, dynamic>> budgets;

//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   late ExpenseCardCubit _expenseCardCubit;

//   String selectedBudget = "Select budget";

//   late List<bool> budgetOption;

//   @override
//   void initState() {
//     _expenseCardCubit =
//         ExpenseCardCubit(userID: widget.userID, screenID: widget.screenID);
//     budgetOption = List.generate(
//       widget.budgets.length,
//       (index) {
//         return false;
//       },
//     );
//     super.initState();
//   }

//   int getIndexForTotalSpent() {
//     for (int i = 0; i < widget.budgets.length; i++) {
//       if (budgetOption[i]) {
//         return i;
//       }
//     }
//     return 0;
//   }

//   String getBudget() {
//     for (int i = 0; i < widget.budgets.length; i++) {
//       if (budgetOption[i]) {
//         return widget.budgets[i]['budgetName'];
//       }
//     }
//     return 'Select budget';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
//     return BlocProvider<ExpenseCardCubit>(
//       create: (context) => _expenseCardCubit,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: kMainBGColor,
//           automaticallyImplyLeading: true,
//           iconTheme: IconThemeData(
//             color: kTextColor,
//           ),
//           title: Text(
//             'Filter Expenses',
//             style: TextStyle(
//               color: kTextColor,
//               fontSize: 22,
//             ),
//           ),
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           color: kMainBGColor,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: kPadding / 2.0),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         ...List.generate(
//                           widget.budgets.length,
//                           (index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 setState(
//                                   () {
//                                     if (budgetOption[index]) {
//                                       budgetOption[index] = false;
//                                     } else {
//                                       budgetOption[index] = true;
//                                       for (int i = 0;
//                                           i < widget.budgets.length;
//                                           i++) {
//                                         if (i != index) {
//                                           budgetOption[i] = false;
//                                         }
//                                       }
//                                     }
//                                     selectedBudget = getBudget();

//                                     if (selectedBudget == "Select budget") {
//                                       _expenseCardCubit.update();
//                                     } else {
//                                       _expenseCardCubit.filterByBudget(
//                                         widget.userID,
//                                         widget.screenID,
//                                         selectedBudget,
//                                       );
//                                     }
//                                   },
//                                 );
//                               },
//                               child: BudgetOption(
//                                 name: widget.budgets[index]['budgetName'],
//                                 hasBeenPressed:
//                                     budgetOption[index] ? true : false,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(kPadding),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedBudget,
//                         style: TextStyle(
//                           color: kTextColor,
//                           fontSize: 22,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Total:',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 22,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             (getBudget() == "Select budget")
//                                 ? '\$0.00'
//                                 : '\$${numberFormat.format(widget.budgets[getIndexForTotalSpent()]['spent'])}',
//                             style: TextStyle(
//                               color: kCurrencyColor,
//                               fontSize: 22,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 BlocBuilder<ExpenseCardCubit, ExpenseCardState>(
//                   builder: (_, state) {
//                     return Padding(
//                       padding: EdgeInsets.all(kPadding),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: kDarkBGColor,
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(kRadiusCurve)),
//                         ),
//                         child: Column(
//                           children: [
//                             ...List.generate(
//                               state.expenseCards.length,
//                               (index) {
//                                 bool displayDivider =
//                                     (index == state.expenseCards.length - 1)
//                                         ? false
//                                         : true;

//                                 Map<String, dynamic> cardInfo =
//                                     state.expenseCards[index];
//                                 return Column(
//                                   children: [
//                                     ExpenseCard(
//                                       description:
//                                           cardInfo['expenseDescription'],
//                                       expenseAmount:
//                                           cardInfo['expenseAmount'].toDouble(),
//                                       expenseDate: cardInfo['expenseDate'],
//                                       budget: cardInfo['budget'],
//                                     ),
//                                     displayDivider
//                                         ? Padding(
//                                             padding: EdgeInsets.only(
//                                               left: kPadding,
//                                             ),
//                                             child: Divider(
//                                               color: Colors.grey.shade800,
//                                               height: 0,
//                                               thickness: 1,
//                                             ),
//                                           )
//                                         : Container(),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BudgetOption extends StatelessWidget {
//   const BudgetOption({
//     Key? key,
//     required this.name,
//     required this.hasBeenPressed,
//   }) : super(key: key);

//   final String name;
//   final bool hasBeenPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: kPadding / 2.0,
//         vertical: kPadding,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: hasBeenPressed ? kThemeColor.withOpacity(0.5) : kThemeColor,
//           borderRadius: BorderRadius.all(
//             Radius.circular(kRadiusCurve),
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: kPadding,
//             vertical: kPadding / 2.0,
//           ),
//           child: Text(
//             name,
//             style: TextStyle(
//               color: kTextColor,
//               fontSize: 18,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
