part of 'screen_total_spent_cubit.dart';

class ScreenTotalSpentState extends Equatable {
  const ScreenTotalSpentState({
    required this.totalSpent,
  });

  final double totalSpent;

  @override
  List<Object> get props => [totalSpent];
}
