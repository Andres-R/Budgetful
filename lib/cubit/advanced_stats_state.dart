part of 'advanced_stats_cubit.dart';

class AdvancedStatsState extends Equatable {
  const AdvancedStatsState({
    required this.advancedCards,
  });

  final List<Map<String, dynamic>> advancedCards;

  @override
  List<Object> get props => [advancedCards];
}
