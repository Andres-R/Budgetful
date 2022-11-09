import 'package:budgetful/database/database_controller.dart';
import 'package:budgetful/screens/login_screen.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late DatabaseController dbController;
  bool clickedYes = false;

  @override
  void initState() {
    super.initState();
    dbController = DatabaseController();
  }

  void deleteAccount() async {
    await dbController.deleteUserExpenseCards(widget.userID);
    await dbController.deleteUserBudgetCards(widget.userID);
    await dbController.deleteUserMonthlyExpenseCards(widget.userID);
    await dbController.deleteUserAccount(widget.userID);
    logout();
  }

  void logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Delete Account",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 22,
          ),
        ),
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
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            !clickedYes
                ? Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          clickedYes = !clickedYes;
                        });
                      },
                      child: const ButtonContainer(text: 'Yes'),
                    ),
                  )
                : Container(),
            clickedYes
                ? Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: GestureDetector(
                      onTap: deleteAccount,
                      child: const ButtonContainer(
                        text: 'Confirm and delete account',
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: kTextColor,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
