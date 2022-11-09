import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'screen_total_spent_state.dart';

class ScreenTotalSpentCubit extends Cubit<ScreenTotalSpentState> {
  ScreenTotalSpentCubit({
    required this.userID,
    required this.screenID,
  }) : super(const ScreenTotalSpentState(totalSpent: 0.00)) {
    initializeTotalSpent();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeTotalSpent() async {
    double spent =
        await dbController.getTotalExpensesForUserInScreen(userID, screenID);
    emit(ScreenTotalSpentState(totalSpent: spent));
  }

  void updateTotalSpent() async {
    double spent =
        await dbController.getTotalExpensesForUserInScreen(userID, screenID);
    emit(ScreenTotalSpentState(totalSpent: spent));
  }
}
