import 'package:bloc/bloc.dart';
import 'package:budgetful/database/database_controller.dart';
import 'package:equatable/equatable.dart';

part 'advanced_budget_stats_state.dart';

class AdvancedBudgetStatsCubit extends Cubit<AdvancedBudgetStatsState> {
  AdvancedBudgetStatsCubit({
    required this.userID,
  }) : super(const AdvancedBudgetStatsState(advancedBudgets: [])) {
    initialize();
  }

  DatabaseController dbController = DatabaseController();
  final int userID;

  void initialize() async {
    List<Map<String, List<Map<String, dynamic>>>> list =
        await dbController.getAllMonthBudgetSummaries(userID);
    emit(AdvancedBudgetStatsState(advancedBudgets: list));
  }
}
