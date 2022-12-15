import 'package:design_generator/core.dart';


class Validator {
  static bool check(Map<String, String> values) {
    bool valid = true;

    values.forEach((key, format) {
      var value = Input.get(key);
      if (format.contains("required")) {
        if (value == null || value.toString().isEmpty) {
          Get.snackbar("$key", "$key is required");
          valid = false;
        }
      }

      if (format.contains("email")) {
        var isValidEmail = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (!isValidEmail) {
          Get.snackbar("$key", "Invalid Email Address");
          valid = false;
        }
      }
    });
    return valid;
  }
}
