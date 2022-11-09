bool validateMonth(String month) {
  List validMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  for (int i = 0; i < validMonths.length; i++) {
    if (equalsIgnoreCase(month, validMonths[i])) {
      return true;
    }
  }
  return false;
}

bool equalsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase() == string2.toLowerCase();
}
