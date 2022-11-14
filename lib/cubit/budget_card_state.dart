part of 'budget_card_cubit.dart';

class BudgetCardState extends Equatable {
  const BudgetCardState({
    required this.budgetCards,
    required this.budgetCardHasBeenEdited,
  });

  final List<Map<String, dynamic>> budgetCards;
  final bool budgetCardHasBeenEdited;

  @override
  List<Object> get props => [budgetCards, budgetCardHasBeenEdited];
}
