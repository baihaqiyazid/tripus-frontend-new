Map<String, dynamic> parseStringToMap(String input) {
  Map<String, dynamic> result = {};

  // Remove leading and trailing curly braces
  input = input.substring(1, input.length - 1);

  // Split by commas to get key-value pairs
  List<String> keyValuePairs = input.split(',');

  for (String pair in keyValuePairs) {
    // Split each pair into key and value
    List<String> parts = pair.split(':');
    String key = parts[0].trim();
    String value = parts[1].trim();

    // Remove quotes from key and value
    key = key.replaceAll('"', "");
    value = value.replaceAll('"', "");

    // Add to the result map
    result[key] = value;
  }

  return result;
}