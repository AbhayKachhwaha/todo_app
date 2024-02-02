class Validator {
  static String? validateDescription(String? description) {
    if (description == null) return null;

    if (description.isEmpty) return "Description can't be empty";

    return null;
  }
}
