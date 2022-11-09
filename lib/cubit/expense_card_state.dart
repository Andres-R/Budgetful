part of 'expense_card_cubit.dart';

class ExpenseCardState extends Equatable {
  const ExpenseCardState({
    required this.expenseCards,
    required this.expenseCardHasBeenAdded,
  });

  final List<Map<String, dynamic>> expenseCards;
  final bool expenseCardHasBeenAdded;

  @override
  List<Object> get props => [expenseCards, expenseCardHasBeenAdded];
}
