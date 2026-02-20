class Client {
  final String srNo;
  final String consigneeName;
  final String mobileNumber;
  final String gstin;
  final String ownerName;
  final String ownerMobile;
  final String purchaseManager;
  final String managerMobile;

  Client({
    required this.srNo,
    required this.consigneeName,
    required this.mobileNumber,
    required this.gstin,
    required this.ownerName,
    required this.ownerMobile,
    required this.purchaseManager,
    required this.managerMobile,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      srNo: map['Sr No'] ?? '',
      consigneeName: map['Consignee Name'] ?? '',
      mobileNumber: map['Mobile Number'] ?? '',
      gstin: map['GSTIN'] ?? '',
      ownerName: map['Owner Name'] ?? '',
      ownerMobile: map['Owner Mobile'] ?? '',
      purchaseManager: map['Purchase Manager'] ?? '',
      managerMobile: map['Manager Mobile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Sr No': srNo,
      'Consignee Name': consigneeName,
      'Mobile Number': mobileNumber,
      'GSTIN': gstin,
      'Owner Name': ownerName,
      'Owner Mobile': ownerMobile,
      'Purchase Manager': purchaseManager,
      'Manager Mobile': managerMobile,
    };
  }
}
