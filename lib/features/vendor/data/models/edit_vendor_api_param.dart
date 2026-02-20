class EditVendorApiParam {
  final String activity = 'edit-vendor';
  final String vCompanyName;
  final String vGSTIN;
  final String vOwnerName;
  final String vOwnerMobileNumber;
  final String vRepresentativeName;
  final String vRepresentativeMobile;
  final String rKey;
  final String uPassword;
  final String uConfirmPassword;
  final String vMobileNumber;
  final String? vAlternateNumber;

  EditVendorApiParam({
    required this.vCompanyName,
    required this.vGSTIN,
    required this.vOwnerName,
    required this.vOwnerMobileNumber,
    required this.vRepresentativeName,
    required this.vRepresentativeMobile,
    required this.rKey,
    required this.uPassword,
    required this.uConfirmPassword,
    required this.vMobileNumber,
    this.vAlternateNumber,
  });
}
