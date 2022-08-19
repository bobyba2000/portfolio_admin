class BaseValidator {
  static String? requiredValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "This is required. Please fill in.";
    }
  }
}
