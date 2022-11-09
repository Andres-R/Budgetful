part of 'user_last_name_cubit.dart';

class UserLastNameState extends Equatable {
  const UserLastNameState({
    required this.userLastName,
  });

  final String userLastName;

  @override
  List<Object> get props => [userLastName];
}
