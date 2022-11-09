class ExpenseCardModel {
  late int expenseCardID;
  late String expenseDescription;
  late double expenseAmount;
  late String expenseDate;
  late String budget;
  late int userID;
  late int screenID;

  ExpenseCardModel({
    required this.expenseCardID,
    required this.expenseDescription,
    required this.expenseAmount,
    required this.expenseDate,
    required this.budget,
    required this.userID,
    required this.screenID,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'expenseCardID': expenseCardID,
      'expenseDescription': expenseDescription,
      'expenseAmount': expenseAmount,
      'expenseDate': expenseDate,
      'budget': budget,
      'userID': userID,
      'screenID': screenID,
    };
    return map;
  }

  ExpenseCardModel.fromMap(Map<String, dynamic> map) {
    expenseCardID = map["expenseCardID"];
    expenseDescription = map["expenseDescription"];
    expenseAmount = map["expenseAmount"];
    expenseDate = map["expenseDate"];
    budget = map["budget"];
    userID = map["userID"];
    screenID = map["screenID"];
  }
}
