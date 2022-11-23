part of 'advanced_budget_stats_cubit.dart';

class AdvancedBudgetStatsState extends Equatable {
  const AdvancedBudgetStatsState({
    required this.advancedBudgets,
  });

  final List<Map<String, List<Map<String, dynamic>>>> advancedBudgets;

  @override
  List<Object> get props => [advancedBudgets];
}
