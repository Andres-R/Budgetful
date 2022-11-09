import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetful/database/database_controller.dart';

part 'user_last_name_state.dart';

class UserLastNameCubit extends Cubit<UserLastNameState> {
  UserLastNameCubit({
    required this.userID,
  }) : super(const UserLastNameState(userLastName: "")) {
    initializeUserLastName();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeUserLastName() async {
    String lastName = await dbController.getUserLastNameFromUser(userID);
    emit(UserLastNameState(userLastName: lastName));
  }

  void updateUserLastName(String newLastName, int userID) async {
    await dbController.updateUserLastName(newLastName, userID);
    String lastName = await dbController.getUserLastNameFromUser(userID);
    emit(UserLastNameState(userLastName: lastName));
  }
}
