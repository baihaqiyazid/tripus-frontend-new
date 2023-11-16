int parseRpToInteger(String rpValue) {
  // Remove non-numeric characters
  String numericString = rpValue.replaceAll(RegExp(r'[^0-9]'), '');

  // Parse the remaining string as an integer
  int parsedValue = int.parse(numericString);

  return parsedValue;
}