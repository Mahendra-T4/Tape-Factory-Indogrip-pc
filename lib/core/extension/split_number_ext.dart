extension PhoneNumberExtension on String {
  String splitNumber() {
    if (this.isEmpty) return '';
    if (this.startsWith('+91')) {
      return this.substring(3).trim();
    }
    if (this.contains('N/A')) {
      return this.replaceAll('N/A', '').trim();
    }
    return this.trim();
  }

  String formatPhoneNumber() {
    String number = splitNumber();
    
    
    if (number.length == 10) {
      return number;
    }
    // If longer than 10 digits, take last 10
    if (number.length > 10) {
      return number.substring(number.length - 10);
    }
    return number;
  }
}
