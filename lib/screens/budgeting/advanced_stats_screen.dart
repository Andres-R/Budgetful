import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/advanced_stats_cubit.dart';
import 'package:budgetful/screens/budgeting/cards/advanced_stat_card.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:intl/intl.dart';

class AdvancedStatsScreen extends StatefulWidget {
  const AdvancedStatsScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<AdvancedStatsScreen> createState() => _AdvancedStatsScreenState();
}

class _AdvancedStatsScreenState extends State<AdvancedStatsScreen> {
  late AdvancedStatsCubit _advancedStatsCubit;

  @override
  void initState() {
    _advancedStatsCubit = AdvancedStatsCubit(userID: widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return BlocProvider<AdvancedStatsCubit>(
      create: (context) => _advancedStatsCubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Advanced Stats',
            style: TextStyle(
              color: kThemeColor,
              fontSize: 22,
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
                BlocBuilder<AdvancedStatsCubit, AdvancedStatsState>(
                  builder: (_, state) {
                    double totalSpent = 0.0;
                    double totalCheck = 0.0;
                    double averageCheckSpentPercent = 0.0;
                    double averageSpent = 0.0;
                    int check0Count = 0;

                    for (int i = 0; i < state.advancedCards.length; i++) {
                      Map<String, dynamic> card = state.advancedCards[i];
                      totalSpent += card['Amount'].toDouble();
                      totalCheck += card['checkAmount'].toDouble();
                      if (card['checkAmount'].toDouble() == 0.0) {
                        check0Count++;
                      } else {
                        averageCheckSpentPercent +=
                            ((card['Amount'].toDouble() /
                                    card['checkAmount'].toDouble()) *
                                100.0);
                      }
                    }

                    double totalSaved = totalCheck - totalSpent;
                    averageCheckSpentPercent /=
                        (state.advancedCards.length - check0Count);
                    averageSpent = totalSpent / state.advancedCards.length;

                    if (state.advancedCards.isEmpty) {
                      averageCheckSpentPercent = 0.0;
                      averageSpent = 0.0;
                    }
                    return SizedBox(
                      height: 170,
                      child: Padding(
                        padding: EdgeInsets.all(kPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total earned',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '\$${numberFormat.format(totalCheck)}',
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total spent',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '\$${numberFormat.format(totalSpent)}',
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total saved',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '\$${numberFormat.format(totalSaved)}',
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Avg. paycheck spent %',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '${averageCheckSpentPercent.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Avg. spent per month',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '\$${numberFormat.format(averageSpent)}',
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<AdvancedStatsCubit, AdvancedStatsState>(
                  builder: (_, state) {
                    return Column(
                      children: [
                        ...List.generate(
                          state.advancedCards.length,
                          (index) {
                            Map<String, dynamic> card =
                                state.advancedCards[index];
                            return AdvancedStatCard(
                              spent: card['Amount'].toDouble(),
                              check: card['checkAmount'].toDouble(),
                              month: card['cardMonth'],
                              year: card['cardYear'],
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
