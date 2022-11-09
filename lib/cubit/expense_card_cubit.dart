import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'expense_card_state.dart';

class ExpenseCardCubit extends Cubit<ExpenseCardState> {
  ExpenseCardCubit({
    required this.userID,
    required this.screenID,
  }) : super(const ExpenseCardState(
            expenseCards: [], expenseCardHasBeenAdded: false)) {
    initializeExpenseCards();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeExpenseCards() async {
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    emit(ExpenseCardState(expenseCards: list, expenseCardHasBeenAdded: false));
  }

  void addExpenseCard(String expenseDescription, double expenseAmount,
      String expenseDate, String budget, int userID, int screenID) async {
    await dbController.insertExpenseCard(expenseDescription, expenseAmount,
        expenseDate, budget, userID, screenID);
    await dbController.updateSpentForBudget(userID, screenID, budget);
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    emit(ExpenseCardState(expenseCards: list, expenseCardHasBeenAdded: true));
  }

  void update() async {
    List<Map<String, dynamic>> list =
        await dbController.getAllExpenseCards(userID, screenID);
    emit(ExpenseCardState(expenseCards: list, expenseCardHasBeenAdded: false));
  }

  void filterByBudget(int userID, int screenID, String budget) async {
    List<Map<String, dynamic>> list =
        await dbController.filterExpensesByBudget(userID, screenID, budget);
    emit(ExpenseCardState(expenseCards: list, expenseCardHasBeenAdded: false));
  }
}
