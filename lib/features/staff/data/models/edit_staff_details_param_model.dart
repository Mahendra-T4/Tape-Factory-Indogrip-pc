class EditStaffModel {
  final String sFName;
  final String sLName;
  final String sLoginEmailID;
  final String sEmailID;
  final String sMobileNumber;
  final String sAltMobileNumber;
  final String sRole;
  final List<String> sAccessPanel;
  final String rKey;

  EditStaffModel({
    required this.sFName,
    required this.sLName,
    required this.sLoginEmailID,
    required this.sEmailID,
    required this.sMobileNumber,
    required this.sAltMobileNumber,
    required this.sRole,
    required this.sAccessPanel,
    required this.rKey,
  });
}
