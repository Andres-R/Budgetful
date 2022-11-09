import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'user_password_state.dart';

class UserPasswordCubit extends Cubit<UserPasswordState> {
  UserPasswordCubit({
    required this.userID,
  }) : super(const UserPasswordState(userPassword: "")) {
    initializeUserPassword();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeUserPassword() async {
    String password = await dbController.getUserPasswordFromUser(userID);
    emit(UserPasswordState(userPassword: password));
  }

  void updateUserPassword(String newPassword, int userID) async {
    await dbController.updateUserPassword(newPassword, userID);
    String password = await dbController.getUserPasswordFromUser(userID);
    emit(UserPasswordState(userPassword: password));
  }
}
