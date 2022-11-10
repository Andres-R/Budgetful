import 'package:budgetful/database/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/monthly_expense_card_cubit.dart';
import 'package:budgetful/screens/budgeting/advanced_stats_screen.dart';
import 'package:budgetful/screens/budgeting/cards/monthly_expense_card.dart';
import 'package:budgetful/screens/budgeting/create%20screens/create_monthly_expense_card_screen.dart';
import 'package:budgetful/screens/budgeting/edit_monthly_expense_card_screen.dart';
import 'package:budgetful/screens/budgeting/monthly_expense_screen.dart';
import 'package:budgetful/screens/login_screen.dart';
import 'package:budgetful/utils/box_decorations/add_button_box_decoration.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/section_title.dart';

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<BudgetingScreen> createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  late MonthlyExpenseCardCubit _monthlyExpenseCardCubit;

  int _pageIndex = 0;

  @override
  void initState() {
    _monthlyExpenseCardCubit = MonthlyExpenseCardCubit(userID: widget.userID);
    super.initState();
  }

  List<Widget> pageViewCards = const [
    PageViewCard(
      header: 'Keep track of your expenses',
      body: 'Add a month to your history and include '
          'your income for that month.',
    ),
    PageViewCard(
      header: 'Create budgets',
      body: 'Add budgets for each month to categorize and filter expenses.',
    ),
    PageViewCard(
      header: 'Create expenses',
      body: 'After adding budgets to your month, add '
          'expenses to keep track of spending.',
    ),
  ];

  void logout() {
    if (widget.userID == kGuestID) {
      deleteData();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void deleteData() async {
    DatabaseController dbController = DatabaseController();
    await dbController.deleteUserExpenseCards(widget.userID);
    await dbController.deleteUserBudgetCards(widget.userID);
    await dbController.deleteUserMonthlyExpenseCards(widget.userID);
    await dbController.deleteUserAccount(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthlyExpenseCardCubit>(
      create: (context) => _monthlyExpenseCardCubit,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: kPadding),
              child: GestureDetector(
                onTap: logout,
                child: Row(
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: kThemeColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.logout,
                      color: kThemeColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: false,
          title: Text(
            "Budgeting",
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
                  padding: EdgeInsets.all(kPadding),
                  child: SizedBox(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          height: 150,
                          child: PageView.builder(
                            onPageChanged: (index) {
                              setState(() {
                                _pageIndex = index;
                              });
                            },
                            itemCount: pageViewCards.length,
                            itemBuilder: (context, index) {
                              return pageViewCards[index];
                            },
                          ),
                        ),
                        Positioned(
                          bottom: -kPadding,
                          child: Row(
                            children: [
                              ...List.generate(
                                3,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: IndicatorDot(
                                        isSelected: _pageIndex == index),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<MonthlyExpenseCardCubit, MonthlyExpenseCardState>(
                  builder: (_, state) {
                    return Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: GestureDetector(
                        onTap: () {
                          if (state.monthlyExpenseCards.isEmpty) {
                            showCustomErrorDialog(context,
                                "Must add a month before seeing advanced statistics");
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return AdvancedStatsScreen(
                                    userID: widget.userID,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: kDarkBGColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(kRadiusCurve),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'See advanced statistics',
                              style: TextStyle(
                                fontSize: 18,
                                color: kCurrencyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<MonthlyExpenseCardCubit, MonthlyExpenseCardState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SectionTitle(title: "History"),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (state.monthlyExpenseCards.isEmpty) {
                                    showCustomErrorDialog(context,
                                        "Must add a month before editing!");
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: _monthlyExpenseCardCubit,
                                            child: EditMonthlyExpenseCardScreen(
                                              userID: widget.userID,
                                              monthlyExpenseCards:
                                                  state.monthlyExpenseCards,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'edit',
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: _monthlyExpenseCardCubit,
                                      child: CreateMonthlyExpenseCardScreen(
                                        userID: widget.userID,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: const ButtonBoxDecoration(
                              label: "Add Month",
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<MonthlyExpenseCardCubit, MonthlyExpenseCardState>(
                  builder: (_, state) {
                    return Column(
                      children: [
                        ...List.generate(
                          state.monthlyExpenseCards.length,
                          (index) {
                            Map<String, dynamic> card =
                                state.monthlyExpenseCards[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return MonthlyExpenseScreen(
                                        userID: widget.userID,
                                        screenID: card['cardID'],
                                        cardMonth: card['cardMonth'],
                                        cardYear: card['cardYear'],
                                        checkAmount:
                                            card['checkAmount'].toDouble(),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: MonthlyExpenseCard(
                                cardMonth: card['cardMonth'],
                                cardYear: card['cardYear'],
                                checkAmount: card['checkAmount'].toDouble(),
                              ),
                            );
                          },
                        ),
                      ],
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

class IndicatorDot extends StatelessWidget {
  const IndicatorDot({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 12,
      decoration: BoxDecoration(
        color: isSelected ? kTextColor : kTextColor.withOpacity(0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(kRadiusCurve),
        ),
      ),
    );
  }
}

class PageViewCard extends StatelessWidget {
  const PageViewCard({
    Key? key,
    required this.header,
    required this.body,
  }) : super(key: key);

  final String header;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: kThemeColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              color: kTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
