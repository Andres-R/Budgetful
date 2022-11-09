import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:budgetful/database/database_controller.dart';
import 'package:intl/intl.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  var dbController;

  @override
  void initState() {
    super.initState();
    dbController = DatabaseController();
  }

  test() async {
    print("testing");

    // if (false) {
    //   await dbController.insertUser(
    //     "Andres",
    //     "Rogers",
    //     "Andrezoski",
    //     "andres@gmail.com",
    //     "123",
    //   );
    //   await dbController.insertUser(
    //     "Juan",
    //     "Pepe",
    //     "Pepito",
    //     "pepe@gmail.com",
    //     "123",
    //   );

    //   await dbController.insertMonthlyExpenseCard("May", 2022, 4000.00, 1);
    //   await dbController.insertMonthlyExpenseCard("June", 2022, 6000.00, 1);
    //   await dbController.insertMonthlyExpenseCard("April", 2022, 5500.00, 2);
    //   await dbController.insertMonthlyExpenseCard("March", 2022, 3000.00, 1);
    //   await dbController.insertMonthlyExpenseCard("February", 2022, 2000.00, 2);

    //   await dbController.insertBudgetCard("Gas", 300.00, 0.00, 1, 1);
    //   await dbController.insertBudgetCard("Braces", 300.00, 0.00, 1, 2);
    //   await dbController.insertBudgetCard("Groceries", 250.00, 0.00, 2, 3);
    //   await dbController.insertBudgetCard("Phone", 50.00, 0.00, 2, 3);
    //   await dbController.insertBudgetCard("Gas", 300.00, 0.00, 1, 2);

    //   await dbController.insertExpenseCard(
    //       "wawa", 54.09, "2022-05-27", "Gas", 1, 1);
    //   await dbController.updateSpentForBudget(1, 1, "Gas");

    //   await dbController.insertExpenseCard(
    //       "shell", 28.99, "2022-05-28", "Gas", 1, 1);
    //   await dbController.updateSpentForBudget(1, 1, "Gas");

    //   await dbController.insertExpenseCard(
    //       "ortho", 300.00, "2022-06-15", "Braces", 1, 2);
    //   await dbController.updateSpentForBudget(1, 2, "Braces");

    //   await dbController.insertExpenseCard(
    //       "wawa", 27.58, "2022-06-18", "Gas", 1, 2);
    //   await dbController.updateSpentForBudget(1, 2, "Gas");

    //   await dbController.insertExpenseCard(
    //       "wawa", 5.00, "2022-06-19", "Gas", 1, 2);
    //   await dbController.updateSpentForBudget(1, 2, "Gas");

    //   await dbController.insertExpenseCard(
    //       "publix", 50.00, "2022-04-20", "Groceries", 2, 3);
    //   await dbController.updateSpentForBudget(2, 3, "Groceries");

    //   await dbController.insertExpenseCard(
    //       "publix", 5.00, "2022-04-25", "Groceries", 2, 3);
    //   await dbController.updateSpentForBudget(2, 3, "Groceries");

    //   await dbController.insertExpenseCard(
    //       "at&t", 50.00, "2022-04-02", "Phone", 2, 3);
    //   await dbController.updateSpentForBudget(2, 3, "Phone");
    // }

    // if (false) {
    //   List<Map<String, dynamic>> allUsers = await dbController.getAllUsers();
    //   print(allUsers);
    // }

    // if (false) {
    //   await dbController.updateMonthlyExpenseCardCheckAmount(6, 5600.00);
    // }

    // if (false) {
    //   List<Map<String, dynamic>> allMonthCards =
    //       await dbController.getAllMonthlyExpenseCards(3);
    //   print(allMonthCards);
    // }

    // if (false) {
    //   List<Map<String, dynamic>> budgetcards =
    //       await dbController.getAllBudgetCards(1, 2);
    //   print(budgetcards);
    // }

    // if (false) {
    //   List<Map<String, dynamic>> expenseCards =
    //       await dbController.getAllExpenseCards(1, 1);
    //   print(expenseCards);
    // }

    // if (false) {
    //   print(await dbController.getTotalExpensesForUser(1));
    // }

    // if (false) {
    //   print(await dbController.getTotalExpensesForUserInScreen(2, 3));
    // }

    // if (false) {
    //   print(await dbController.getTotalBudgetLimitForUserInScreen(1, 2));
    // }

    // if (false) {
    //   print(await dbController.getUser("andres@gmail.com", "123"));
    // }

    // if (false) {
    //   print(await dbController.getUserByID(9));
    // }

    // if (false) {
    //   print(await dbController.getAllUsers());
    // }

    // if (false) {
    //   print(await dbController.getCardIDFromMonthlyExpenseCard(
    //       "May", 2022, 4000.00, 1));
    //   print(await dbController.getCardIDFromMonthlyExpenseCard(
    //       "April", 2022, 5500.00, 2));
    // }

    // if (false) {
    //   print(
    //       await dbController.getAllExpenseCardsByScreenAndBudget(1, 1, 'Gas'));
    // }

    // if (false) {
    //   print(await dbController.getUserAdvancedSpentDetails(1));
    // }

    // if (false) {
    //   await dbController.updateUserEmail('e@e', 3);
    // }

    // if (false) {
    //   print(await dbController.getUserEmailFromUser(3));
    // }

    // if (false) {
    //   print(await dbController.isEmailTaken('e@e'));
    // }

    // if (false) {
    //   await dbController.deleteDB();
    //   print("Database deleted");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: test,
          child: Container(
            height: 50,
            width: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                )
              ],
            ),
            child: const Center(child: Text("Test")),
          ),
        ),
      ),
    );
  }
}
