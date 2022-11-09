import 'package:bloc/bloc.dart';
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
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: list));
  }

  // don't need userID parameter
  void addMonthlyExpenseCard(
      String cardMonth, int cardYear, double checkAmount, int userID) async {
    await dbController.insertMonthlyExpenseCard(
        cardMonth, cardYear, checkAmount, userID);
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: list));
  }

  void updateMonthlyExpenseCardIncome(
      int cardID, double newAmount, int userID) async {
    await dbController.updateMonthlyExpenseCardCheckAmount(cardID, newAmount);
    List<Map<String, dynamic>> list =
        await dbController.getAllMonthlyExpenseCards(userID);
    emit(MonthlyExpenseCardState(monthlyExpenseCards: list));
  }
}
