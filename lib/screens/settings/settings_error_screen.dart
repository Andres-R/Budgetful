import 'package:budgetful/database/database_controller.dart';
import 'package:budgetful/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:budgetful/utils/constants.dart';

class SettingsErrorScreen extends StatefulWidget {
  const SettingsErrorScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<SettingsErrorScreen> createState() => _SettingsErrorScreenState();
}

class _SettingsErrorScreenState extends State<SettingsErrorScreen> {
  void logout() {
    deleteData();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void deleteData() async {
    DatabaseController dbController = DatabaseController();
    await dbController.deleteUserExpenseCards(widget.userID);
    await dbController.deleteUserBudgetCards(widget.userID);
    await dbController.deleteUserMonthlyExpenseCards(widget.userID);
    await dbController.deleteUserAccount(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: kPadding),
            child: GestureDetector(
              onTap: logout,
              child: Row(
                children: [
                  Text(
                    'Log out',
                    style: TextStyle(
                      color: kThemeColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.logout,
                    color: kThemeColor,
                  ),
                ],
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: kMainBGColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(kPadding),
              child: Text(
                'Account creation needed',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kPadding),
              child: Text(
                'After creating an account, you will also be able to access user settings and save your data.',
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
