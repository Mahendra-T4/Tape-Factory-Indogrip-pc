class ChangeStaffParam {
  final String rKey;
  final String rPanel;
  final String rStatus;
  final String? statusReason;

  ChangeStaffParam({
    required this.rKey,
    required this.rPanel,
    required this.rStatus,
    this.statusReason,
  });
}
