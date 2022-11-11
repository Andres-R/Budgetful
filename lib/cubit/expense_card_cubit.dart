import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'expense_card_state.dart';

class ExpenseCardCubit extends Cubit<ExpenseCardState> {
  ExpenseCardCubit({
    required this.userID,
    required this.screenID,
  }) : super(const ExpenseCardState(
            expenseCards: [], expenseCardHasBeenEdited: false)) {
    initializeExpenseCards();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeExpenseCards() async {
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortExpenseCards);
    emit(ExpenseCardState(
        expenseCards: sorted, expenseCardHasBeenEdited: false));
  }

  void addExpenseCard(String expenseDescription, double expenseAmount,
      String expenseDate, String budget, int userID, int screenID) async {
    await dbController.insertExpenseCard(expenseDescription, expenseAmount,
        expenseDate, budget, userID, screenID);
    await dbController.updateSpentForBudget(userID, screenID, budget);
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortExpenseCards);
    emit(
        ExpenseCardState(expenseCards: sorted, expenseCardHasBeenEdited: true));
  }

  void deleteExpenseCard(
      int id, String budget, int userID, int screenID) async {
    await dbController.deleteExpenseCard(id);
    await dbController.updateSpentForBudget(userID, screenID, budget);
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortExpenseCards);
    emit(
        ExpenseCardState(expenseCards: sorted, expenseCardHasBeenEdited: true));
  }

  void update() async {
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortExpenseCards);
    emit(ExpenseCardState(
        expenseCards: sorted, expenseCardHasBeenEdited: false));
  }

  void filterByBudget(int userID, int screenID, String budget) async {
    List<Map<String, dynamic>> sorted = [];
    List<Map<String, dynamic>> list =
        await dbController.filterExpensesByBudget(userID, screenID, budget);
    for (Map<String, dynamic> map in list) {
      sorted.add(map);
    }
    sorted.sort(sortExpenseCards);
    emit(ExpenseCardState(
        expenseCards: sorted, expenseCardHasBeenEdited: false));
  }

  int sortExpenseCards(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    String date1 = map1['expenseDate'].replaceAll('-', '');
    String date2 = map2['expenseDate'].replaceAll('-', '');
    int one = int.parse(date1);
    int two = int.parse(date2);
    if (one > two) {
      return 1;
    } else if (two > one) {
      return -1;
    } else {
      return 0;
    }
  }
}
