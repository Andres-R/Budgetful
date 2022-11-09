class MonthlyExpenseCardModel {
  late int cardID;
  late String cardMonth;
  late int cardYear;
  late double checkAmount;
  late int userID;

  MonthlyExpenseCardModel({
    required this.cardID,
    required this.cardMonth,
    required this.cardYear,
    required this.checkAmount,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cardID': cardID,
      'cardMonth': cardMonth,
      'cardYear': cardYear,
      'checkAmount': checkAmount,
      'userID': userID,
    };
    return map;
  }

  MonthlyExpenseCardModel.fromMap(Map<String, dynamic> map) {
    cardID = map["cardID"];
    cardMonth = map["cardMonth"];
    cardYear = map["cardYear"];
    checkAmount = map["checkAmount"];
    userID = map["userID"];
  }
}
