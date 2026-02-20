class UStatus {
  final String activity = 'change-status';
  final String rKey;
  final String rStatus;
  final String rPanel;
  final String statusReason;

  UStatus({
    required this.rKey,
    required this.rStatus,
    required this.rPanel,
    required this.statusReason,
  });
}
