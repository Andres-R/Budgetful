part of 'budget_card_cubit.dart';

class BudgetCardState extends Equatable {
  const BudgetCardState({
    required this.budgetCards,
    required this.budgetCardHasBeenAdded,
  });

  final List<Map<String, dynamic>> budgetCards;
  final bool budgetCardHasBeenAdded;

  @override
  List<Object> get props => [budgetCards, budgetCardHasBeenAdded];
}
