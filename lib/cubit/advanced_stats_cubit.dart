import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'advanced_stats_state.dart';

class AdvancedStatsCubit extends Cubit<AdvancedStatsState> {
  AdvancedStatsCubit({
    required this.userID,
  }) : super(const AdvancedStatsState(advancedCards: [])) {
    initializeAdvancedCards();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeAdvancedCards() async {
    List<Map<String, dynamic>> list =
        await dbController.getUserAdvancedSpentDetails(userID);
    emit(AdvancedStatsState(advancedCards: list));
  }
}
