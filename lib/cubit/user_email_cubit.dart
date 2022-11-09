import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'user_email_state.dart';

class UserEmailCubit extends Cubit<UserEmailState> {
  UserEmailCubit({
    required this.userID,
  }) : super(const UserEmailState(userEmail: "")) {
    initializeUserEmail();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeUserEmail() async {
    String email = await dbController.getUserEmailFromUser(userID);
    emit(UserEmailState(userEmail: email));
  }

  void updateUserEmail(String newEmail, int userID) async {
    await dbController.updateUserEmail(newEmail, userID);
    String email = await dbController.getUserEmailFromUser(userID);
    emit(UserEmailState(userEmail: email));
  }
}
