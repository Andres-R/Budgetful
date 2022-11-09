part of 'user_first_name_cubit.dart';

class UserFirstNameState extends Equatable {
  const UserFirstNameState({
    required this.userFirstName,
  });

  final String userFirstName;

  @override
  List<Object> get props => [userFirstName];
}
