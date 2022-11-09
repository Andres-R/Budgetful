import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'user_first_name_state.dart';

class UserFirstNameCubit extends Cubit<UserFirstNameState> {
  UserFirstNameCubit({
    required this.userID,
  }) : super(const UserFirstNameState(userFirstName: "")) {
    initializeUserFirstName();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeUserFirstName() async {
    String firstName = await dbController.getUserFirstNameFromUser(userID);
    emit(UserFirstNameState(userFirstName: firstName));
  }

  void updateUserFirstName(String newFirstName, int userID) async {
    await dbController.updateUserFirstName(newFirstName, userID);
    String firstName = await dbController.getUserFirstNameFromUser(userID);
    emit(UserFirstNameState(userFirstName: firstName));
  }
}
