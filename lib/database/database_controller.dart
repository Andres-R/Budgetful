import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseController {
  late Database _db;
  bool initialized = false;
  static const String databaseName = 'budgetfuldb.db';
  static const int version = 1;

  Future<Database> get db async {
    if (initialized) {
      return _db;
    }
    _db = await initDB();
    initialized = true;
    return _db;
  }

  initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    var db = await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE AppUser (
        userID INTEGER PRIMARY KEY AUTOINCREMENT,
        userFirstName TEXT NOT NULL,
        userLastName TEXT NOT NULL,
        userName TEXT NOT NULL,
        userEmail TEXT NOT NULL UNIQUE,
        userPassword TEXT NOT NULL
        )''');
    await db.execute('''CREATE TABLE MonthlyExpenseCard (
        cardID INTEGER PRIMARY KEY AUTOINCREMENT,
        cardMonth TEXT NOT NULL,
        cardYear INTEGER NOT NULL,
        checkAmount DECIMAL(10,2) NOT NULL,
        userID INTEGER NOT NULL,
        FOREIGN KEY(userID) REFERENCES AppUser(userID) ON DELETE SET NULL
        )''');
    await db.execute('''CREATE TABLE BudgetCard (
        budgetCardID INTEGER PRIMARY KEY AUTOINCREMENT,
        budgetName TEXT NOT NULL,
        budgetLimit DECIMAL(10,2) NOT NULL,
        spent DECIMAL(10,2) NOT NULL,
        userID INTEGER NOT NULL,
        screenID INTEGER NOT NULL,
        FOREIGN KEY(userID) REFERENCES AppUser(userID) ON DELETE SET NULL,
        FOREIGN KEY(screenID) REFERENCES MonthlyExpenseCard(cardID) ON DELETE SET NULL
        )''');
    await db.execute('''CREATE TABLE ExpenseCard (
        expenseCardID INTEGER PRIMARY KEY AUTOINCREMENT,
        expenseDescription TEXT NOT NULL,
        expenseAmount DECIMAL(10,2) NOT NULL,
        expenseDate DATE NOT NULL,
        budget TEXT NOT NULL,
        userID INTEGER NOT NULL,
        screenID INTEGER NOT NULL,
        FOREIGN KEY(budget) REFERENCES BudgetCard(budgetName) ON DELETE SET NULL,
        FOREIGN KEY(userID) REFERENCES AppUser(userID) ON DELETE SET NULL,
        FOREIGN KEY(screenID) REFERENCES MonthlyExpenseCard(cardID) ON DELETE SET NULL
        )''');
  }

  // works? [yes]
  // deletes database. Use if you want to make changes to table and reset
  void deleteDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    await deleteDatabase(path);
  }

  // works? [yes]
  Future<int> insertUser(String firstName, String lastName, String username,
      String email, String password) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      "INSERT INTO AppUser(userFirstName, userLastName, userName, userEmail, userPassword) VALUES(?, ?, ?, ?, ?);",
      [firstName, lastName, username, email, password],
    );
    return response;
  }

  // works? [yes]
  Future<int> insertMonthlyExpenseCard(
      String cardMonth, int cardYear, double checkAmount, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      "INSERT INTO MonthlyExpenseCard(cardMonth, cardYear, checkAmount, userID) VALUES(?, ?, ?, ?);",
      [cardMonth, cardYear, checkAmount, userID],
    );
    return response;
  }

  // works? [yes]
  // spent should be properly updated with UPDATE query
  Future<int> insertBudgetCard(String budgetName, double budgetLimit,
      double spent, int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      "INSERT INTO BudgetCard(budgetName, budgetLimit, spent, userID, screenID) VALUES(?, ?, ?, ?, ?);",
      [budgetName, budgetLimit, spent, userID, screenID],
    );
    return response;
  }

  // works? [yes]
  // expenseDate is a String here but DATE in table
  Future<int> insertExpenseCard(String expenseDescription, double expenseAmount,
      String expenseDate, String budget, int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      "INSERT INTO ExpenseCard(expenseDescription, expenseAmount, expenseDate, budget, userID, screenID) VALUES(?, ?, ?, ?, ?, ?);",
      [
        expenseDescription,
        expenseAmount,
        expenseDate,
        budget,
        userID,
        screenID
      ],
    );
    return response;
  }

  //works? [yes]
  Future<Map<String, dynamic>> getUser(String email, String password) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM AppUser WHERE userEmail = ? AND userPassword = ?;",
      [email, password],
    );

    if (response.isEmpty) {
      return {
        "userID": -1,
        "userName": -1,
        "userEmail": -1,
        "userPassword": -1,
      };
    }
    Map<String, dynamic> result = response[0];
    return result;
  }

  // works? [yes]
  Future<Map<String, dynamic>> getUserByID(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM AppUser WHERE userID = ?;",
      [userID],
    );

    if (response.isEmpty) {
      return {
        "userID": -1,
        "userName": -1,
        "userEmail": -1,
        "userPassword": -1,
      };
    }
    Map<String, dynamic> result = response[0];
    return result;
  }

  // works? [yes]
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    var dbClient = await db;
    var response = await dbClient.rawQuery("SELECT * FROM AppUser;");
    return response;
  }

  // works? [yes]
  Future<int> getCardIDFromMonthlyExpenseCard(
      String cardMonth, int cardYear, double checkAmount, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT MonthlyExpenseCard.cardID FROM MonthlyExpenseCard WHERE MonthlyExpenseCard.cardMonth = ? AND MonthlyExpenseCard.cardYear = ? AND MonthlyExpenseCard.checkAmount = ? AND MonthlyExpenseCard.userID = ?;",
      [cardMonth, cardYear, checkAmount, userID],
    );

    int screenID = -1;
    if (response.isNotEmpty) {
      screenID = response[0]['cardID'] as int;
    }
    return screenID;
  }

  // works? [yes]
  // 0. get total spent for user
  Future<double> getTotalExpensesForUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT SUM(ExpenseCard.expenseAmount) as Amount FROM ExpenseCard WHERE ExpenseCard.userID = ?;",
      [userID],
    );

    Map<String, dynamic> result = response[0];
    double amount = 0;
    if (result['Amount'] is int) {
      amount = result['Amount'] * 1.0;
    } else if (result['Amount'] is double) {
      amount = result['Amount'];
    }
    return amount;
  }

  // works? [yes]
  // 1. get total spent for user in screen
  Future<double> getTotalExpensesForUserInScreen(
      int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT SUM(ExpenseCard.expenseAmount) as Amount FROM ExpenseCard WHERE ExpenseCard.userID = ? AND ExpenseCard.screenID = ?;",
      [userID, screenID],
    );

    Map<String, dynamic> result = response[0];
    double amount = 0;
    if (result['Amount'] is int) {
      amount = result['Amount'] * 1.0;
    } else if (result['Amount'] is double) {
      amount = result['Amount'];
    }
    return amount;
  }

  // works? [yes]
  // 2. get total budget limit for user in screen
  Future<double> getTotalBudgetLimitForUserInScreen(
      int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT SUM(BudgetCard.budgetLimit) AS Amount FROM BudgetCard WHERE BudgetCard.userID = ? AND BudgetCard.screenID = ?;",
      [userID, screenID],
    );

    Map<String, dynamic> result = response[0];
    double amount = 0;
    if (result['Amount'] is int) {
      amount = result['Amount'] * 1.0;
    } else if (result['Amount'] is double) {
      amount = result['Amount'];
    }
    return amount;
  }

  // works? [yes]
  // 3. get all expense cards for user in screen
  Future<List<Map<String, dynamic>>> getAllExpenseCards(
      int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM ExpenseCard WHERE ExpenseCard.userID = ? AND ExpenseCard.screenID = ?;",
      [userID, screenID],
    );
    return response;
  }

  // works? [yes]
  // 4. get all budget cards for user in screen
  Future<List<Map<String, dynamic>>> getAllBudgetCards(
      int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM BudgetCard WHERE BudgetCard.userID = ? AND BudgetCard.screenID = ?;",
      [userID, screenID],
    );
    return response;
  }

  // works? [yes]
  // 5. get all monthly expense cards for user
  Future<List<Map<String, dynamic>>> getAllMonthlyExpenseCards(
      int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM MonthlyExpenseCard WHERE MonthlyExpenseCard.userID = ?;",
      [userID],
    );
    return response;
  }

  // works? [yes]
  // 6. update total spent in a budget for user in screen for budget
  Future<int> updateSpentForBudget(
      int userID, int screenID, String budget) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT SUM(ExpenseCard.expenseAmount) AS Amount FROM ExpenseCard WHERE ExpenseCard.userID = ? AND ExpenseCard.screenID = ? AND ExpenseCard.budget = ?;",
      [userID, screenID, budget],
    );

    Map<String, dynamic> result = response[0];
    double amount = 0;
    if (result['Amount'] is int) {
      amount = result['Amount'] * 1.0;
    } else if (result['Amount'] is double) {
      amount = result['Amount'];
    }

    var update = await dbClient.rawUpdate(
      "UPDATE BudgetCard SET spent = ? WHERE BudgetCard.userID = ? AND BudgetCard.screenID = ? AND BudgetCard.budgetName = ?;",
      [amount, userID, screenID, budget],
    );
    return update;
  }

  // works? [yes]
  Future<List<Map<String, dynamic>>> filterExpensesByBudget(
      int userID, int screenID, String budget) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM ExpenseCard WHERE ExpenseCard.userID = ? AND ExpenseCard.screenID = ? AND ExpenseCard.budget = ?;",
      [userID, screenID, budget],
    );
    return response;
  }

  // works? [yes]
  Future<List<Map<String, dynamic>>> getUserAdvancedSpentDetails(
      int userID) async {
    var dbClient = await db;
    var response1 = await dbClient.rawQuery(
      "SELECT COALESCE(SUM(ExpenseCard.expenseAmount), 0) AS Amount, ExpenseCard.userID, ExpenseCard.screenID, MonthlyExpenseCard.cardMonth, MonthlyExpenseCard.checkAmount, MonthlyExpenseCard.cardYear FROM ExpenseCard, MonthlyExpenseCard WHERE ExpenseCard.screenID = MonthlyExpenseCard.cardID AND ExpenseCard.userID = ? GROUP BY ExpenseCard.screenID;",
      [userID],
    );
    var response2 = await dbClient.rawQuery(
      'SELECT MonthlyExpenseCard.cardID AS screenID, MonthlyExpenseCard.cardMonth, MonthlyExpenseCard.checkAmount FROM MonthlyExpenseCard WHERE MonthlyExpenseCard.userID = ?;',
      [userID],
    );
    // copy response1 into output
    List<Map<String, dynamic>> output = [];
    for (Map<String, dynamic> map in response1) {
      output.add(map);
    }
    // populate output with proper maps
    for (int i = 0; i < response1.length; i++) {
      for (int j = 0; j < response2.length; j++) {
        if (response1[i]['screenID'] != response2[j]['screenID']) {
          bool outputContainsMap2ScreenID = false;
          for (int k = 0; k < output.length; k++) {
            if (output[k]['screenID'] == response2[j]['screenID']) {
              outputContainsMap2ScreenID = true;
            }
          }
          if (!outputContainsMap2ScreenID) {
            output.add({
              "Amount": 0.0,
              "userID": userID,
              "screenID": response2[j]['screenID'],
              "cardMonth": response2[j]['cardMonth'],
              "checkAmount": response2[j]['checkAmount'],
              "cardYear": response1[i]['cardYear'],
            });
          }
        }
      }
    }
    // print('');
    // for (Map<String, dynamic> map in response1) {
    //   print(map);
    // }
    // print('');
    // for (Map<String, dynamic> map in response2) {
    //   print(map);
    // }
    // print('');
    // for (Map<String, dynamic> map in output) {
    //   print(map);
    // }
    // print(output.length);
    return output;
  }

  // works? [yes]
  Future<int> updateMonthlyExpenseCardCheckAmount(
      int cardID, double newAmount) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE MonthlyExpenseCard SET checkAmount = ? WHERE cardID = ?;",
      [newAmount, cardID],
    );
    return update;
  }

  // works? [yes]
  Future<int> updateUserEmail(String newEmail, int userID) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE AppUser SET userEmail = ? WHERE userID = ?;",
      [newEmail, userID],
    );
    return update;
  }

  // works? [yes]
  Future<String> getUserEmailFromUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT userEmail FROM AppUser WHERE AppUser.userID = ?;",
      [userID],
    );

    String email = '';
    if (response.isEmpty) {
      email = 'N/A';
    } else {
      Map<String, dynamic> result = response[0];
      email = result['userEmail'];
    }
    return email;
  }

  // works? [yes]
  Future<int> updateUserPassword(String newPassword, int userID) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE AppUser SET userPassword = ? WHERE userID = ?;",
      [newPassword, userID],
    );
    return update;
  }

  // works? [yes]
  Future<String> getUserPasswordFromUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT userPassword FROM AppUser WHERE AppUser.userID = ?;",
      [userID],
    );

    String password = '';
    if (response.isEmpty) {
      password = 'N/A';
    } else {
      Map<String, dynamic> result = response[0];
      password = result['userPassword'];
    }
    return password;
  }

  // works? [yes]
  Future<int> updateUserName(String newUserName, int userID) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE AppUser SET userName = ? WHERE userID = ?;",
      [newUserName, userID],
    );
    return update;
  }

  // works? [yes]
  Future<String> getUserNameFromUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT userName FROM AppUser WHERE AppUser.userID = ?;",
      [userID],
    );

    String userName = '';
    if (response.isEmpty) {
      userName = 'N/A';
    } else {
      Map<String, dynamic> result = response[0];
      userName = result['userName'];
    }
    return userName;
  }

  // works? [yes]
  Future<int> updateUserFirstName(String newUserFirstName, int userID) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE AppUser SET userFirstName = ? WHERE userID = ?;",
      [newUserFirstName, userID],
    );
    return update;
  }

  // works? [yes]
  Future<String> getUserFirstNameFromUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT userFirstName FROM AppUser WHERE AppUser.userID = ?;",
      [userID],
    );

    String userFirstName = '';
    if (response.isEmpty) {
      userFirstName = 'N/A';
    } else {
      Map<String, dynamic> result = response[0];
      userFirstName = result['userFirstName'];
    }
    return userFirstName;
  }

  // works? [yes]
  Future<int> updateUserLastName(String newUserLastName, int userID) async {
    var dbClient = await db;
    var update = await dbClient.rawUpdate(
      "UPDATE AppUser SET userLastName = ? WHERE userID = ?;",
      [newUserLastName, userID],
    );
    return update;
  }

  // works? [yes]
  Future<String> getUserLastNameFromUser(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT userLastName FROM AppUser WHERE AppUser.userID = ?;",
      [userID],
    );

    String userLastName = '';
    if (response.isEmpty) {
      userLastName = 'N/A';
    } else {
      Map<String, dynamic> result = response[0];
      userLastName = result['userLastName'];
    }
    return userLastName;
  }

  // works? [yes]
  Future<bool> isEmailTaken(String email) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      "SELECT * FROM AppUser WHERE AppUser.userEmail = ?;",
      [email],
    );

    if (response.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // works? [yes]
  Future<int> deleteUserAccount(int userID) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM AppUser WHERE userID = ?;",
      [userID],
    );
    return delete;
  }

  // works? [yes]
  Future<int> deleteUserMonthlyExpenseCards(int userID) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM MonthlyExpenseCard WHERE userID = ?;",
      [userID],
    );
    return delete;
  }

  // works? [yes]
  Future<int> deleteUserBudgetCards(int userID) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM BudgetCard WHERE userID = ?;",
      [userID],
    );
    return delete;
  }

  // works? [yes]
  Future<int> deleteUserExpenseCards(int userID) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM ExpenseCard WHERE userID = ?;",
      [userID],
    );
    return delete;
  }

  // works? [notyettested]
  Future<int> deleteExpenseCard(int id) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM ExpenseCard WHERE expenseCardID = ?;",
      [id],
    );
    return delete;
  }
}
