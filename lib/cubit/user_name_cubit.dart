import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'user_name_state.dart';

class UserNameCubit extends Cubit<UserNameState> {
  UserNameCubit({
    required this.userID,
  }) : super(const UserNameState(userName: "")) {
    initializeUserName();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeUserName() async {
    String userName = await dbController.getUserNameFromUser(userID);
    emit(UserNameState(userName: userName));
  }

  void updateUserName(String newUserName, int userID) async {
    await dbController.updateUserName(newUserName, userID);
    String userName = await dbController.getUserNameFromUser(userID);
    emit(UserNameState(userName: userName));
  }
}
