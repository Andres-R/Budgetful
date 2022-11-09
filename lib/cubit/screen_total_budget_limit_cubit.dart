import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'screen_total_budget_limit_state.dart';

class ScreenTotalBudgetLimitCubit extends Cubit<ScreenTotalBudgetLimitState> {
  ScreenTotalBudgetLimitCubit({
    required this.userID,
    required this.screenID,
  }) : super(const ScreenTotalBudgetLimitState(totalBudgetLimit: 0.00)) {
    initializeTotalBudgetLimit();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeTotalBudgetLimit() async {
    double limit =
        await dbController.getTotalBudgetLimitForUserInScreen(userID, screenID);
    emit(ScreenTotalBudgetLimitState(totalBudgetLimit: limit));
  }

  void updateTotalBudgetLimit() async {
    double limit =
        await dbController.getTotalBudgetLimitForUserInScreen(userID, screenID);
    emit(ScreenTotalBudgetLimitState(totalBudgetLimit: limit));
  }
}
