part of 'screen_total_budget_limit_cubit.dart';

class ScreenTotalBudgetLimitState extends Equatable {
  const ScreenTotalBudgetLimitState({
    required this.totalBudgetLimit,
  });

  final double totalBudgetLimit;

  @override
  List<Object> get props => [totalBudgetLimit];
}
