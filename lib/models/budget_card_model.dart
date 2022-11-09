class BudgetCardModel {
  late int budgetCardID;
  late String budgetName;
  late double budgetLimit;
  late double spent;
  late int userID;
  late int screenID;

  BudgetCardModel({
    required this.budgetCardID,
    required this.budgetName,
    required this.budgetLimit,
    required this.spent,
    required this.userID,
    required this.screenID,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'budgetCardID': budgetCardID,
      'budgetName': budgetName,
      'budgetLimit': budgetLimit,
      'spent': spent,
      'userID': userID,
      'screenID': screenID,
    };
    return map;
  }

  BudgetCardModel.fromMap(Map<String, dynamic> map) {
    budgetCardID = map["budgetCardID"];
    budgetName = map["budgetName"];
    budgetLimit = map["budgetLimit"];
    spent = map["spent"];
    userID = map["userID"];
    screenID = map["screenID"];
  }
}
