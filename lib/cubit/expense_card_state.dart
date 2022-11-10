part of 'expense_card_cubit.dart';

class ExpenseCardState extends Equatable {
  const ExpenseCardState({
    required this.expenseCards,
    required this.expenseCardHasBeenEdited,
  });

  final List<Map<String, dynamic>> expenseCards;
  final bool expenseCardHasBeenEdited;

  @override
  List<Object> get props => [expenseCards, expenseCardHasBeenEdited];
}
