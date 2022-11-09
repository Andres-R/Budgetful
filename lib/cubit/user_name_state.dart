part of 'user_name_cubit.dart';

class UserNameState extends Equatable {
  const UserNameState({
    required this.userName,
  });

  final String userName;

  @override
  List<Object> get props => [userName];
}
