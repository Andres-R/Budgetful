part of 'monthly_expense_card_cubit.dart';

class MonthlyExpenseCardState extends Equatable {
  const MonthlyExpenseCardState({
    required this.monthlyExpenseCards,
  });

  final List<Map<String, dynamic>> monthlyExpenseCards;

  @override
  List<Object> get props => [monthlyExpenseCards];
}
