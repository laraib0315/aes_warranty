class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^03[0-9]{9}$').hasMatch(phone);
  }

  static bool isValidUsername(String username) {
    return username.length >= 3 && username.length <= 20;
  }

  static bool isPositiveNumber(double value) {
    return value > 0;
  }
}
