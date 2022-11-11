import 'package:bloc/bloc.dart';
import 'package:budgetful/utils/number_to_month.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'monthly_expense_card_state.dart';

class MonthlyExpenseCardCubit extends Cubit<MonthlyExpenseCardState> {
  MonthlyExpenseCardCubit({
    required this.userID,
  }) : super(const MonthlyExpenseCardState(monthlyExpenseCards: [])) {
    initializeMonthlyExpeseCards();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeMonthlyExpeseCards() async {
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortMonthCards);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: sorted));
  }

  // don't need userID parameter
  void addMonthlyExpenseCard(
      String cardMonth, int cardYear, double checkAmount, int userID) async {
    await dbController.insertMonthlyExpenseCard(
        cardMonth, cardYear, checkAmount, userID);
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortMonthCards);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: sorted));
  }

  void updateMonthlyExpenseCardIncome(
      int cardID, double newAmount, int userID) async {
    await dbController.updateMonthlyExpenseCardCheckAmount(cardID, newAmount);
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortMonthCards);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: sorted));
  }
}

int sortMonthCards(
  Map<String, dynamic> map1,
  Map<String, dynamic> map2,
) {
  String month1 = monthToNumberWith0['${map1['cardMonth']}']!;
  String month2 = monthToNumberWith0['${map2['cardMonth']}']!;
  String year1 = map1['cardYear'].toString();
  String year2 = map2['cardYear'].toString();
  int date1 = int.parse('$year1$month1');
  int date2 = int.parse('$year2$month2');
  if (date1 > date2) {
    return 1;
  } else if (date2 > date1) {
    return -1;
  } else {
    return 0;
  }
}
