class EditStaffApiParam {
  final String activity = 'add-staff';
  final String uFirstName;
  final String uLastName;
  final String uEmail;
  final String uPassword;
  final String uPersonalEmail;
  final String uMobileNumber;
  final String uAlternateNumber;
  final String uRole;
  final List<String> uAccessPanel;
  final String uConfirmPassword;
  final String rKey;

  EditStaffApiParam({
    required this.uFirstName,
    required this.uLastName,
    required this.uEmail,
    required this.uPassword,
    required this.uPersonalEmail,
    required this.uMobileNumber,
    required this.uAlternateNumber,
    required this.uRole,
    required this.uAccessPanel,
    required this.uConfirmPassword,
    required this.rKey,
  });
}
