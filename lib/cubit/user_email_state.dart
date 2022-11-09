part of 'user_email_cubit.dart';

class UserEmailState extends Equatable {
  const UserEmailState({
    required this.userEmail,
  });

  final String userEmail;

  @override
  List<Object> get props => [userEmail];
}
