class Regex {
  static const String phone = r'^[6-9]\d{9}$';
  static const String email = r'[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+';
  static const String password =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
  static const String name = r'^[A-Za-z][A-Za-z\s]{1,29}$';
  static const String gstin =
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
}
