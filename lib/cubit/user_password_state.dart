part of 'user_password_cubit.dart';

class UserPasswordState extends Equatable {
  const UserPasswordState({
    required this.userPassword,
  });

  final String userPassword;

  @override
  List<Object> get props => [userPassword];
}
