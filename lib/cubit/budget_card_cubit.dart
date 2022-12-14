import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'budget_card_state.dart';

class BudgetCardCubit extends Cubit<BudgetCardState> {
  BudgetCardCubit({
    required this.userID,
    required this.screenID,
  }) : super(const BudgetCardState(
            budgetCards: [], budgetCardHasBeenEdited: false)) {
    initializeBudgetCards();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeBudgetCards() async {
    List<Map<String, dynamic>> list =
        await dbController.getAllBudgetCards(userID, screenID);
    emit(BudgetCardState(budgetCards: list, budgetCardHasBeenEdited: false));
  }

  void addBudgetCard(String budgetName, double budgetLimit, double spent,
      int userID, int screenID) async {
    await dbController.insertBudgetCard(
        budgetName, budgetLimit, spent, userID, screenID);
    List<Map<String, dynamic>> list =
        await dbController.getAllBudgetCards(userID, screenID);
    emit(BudgetCardState(budgetCards: list, budgetCardHasBeenEdited: true));
  }

  void updateBudgetCards() async {
    List<Map<String, dynamic>> list =
        await dbController.getAllBudgetCards(userID, screenID);
    emit(BudgetCardState(budgetCards: list, budgetCardHasBeenEdited: false));
  }

  void updateBudgetLimit(
      double newLimit, int cardID, int userID, int screenID) async {
    await dbController.updateBudgetLimit(newLimit, cardID);
    List<Map<String, dynamic>> list =
        await dbController.getAllBudgetCards(userID, screenID);
    emit(BudgetCardState(budgetCards: list, budgetCardHasBeenEdited: true));
  }
}
