import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/features/notifications/model/read_notification_model.dart';
import 'package:indogrip/features/notifications/repository/notification_repo.dart';

final readNotificationProvider =
    StateNotifierProvider.family<
      NotificationNotifier,
      NotificationState,
      String
    >((ref, notificationKey) => NotificationNotifier());

enum Notification { initial, loading, success, error }

class NotificationState {
  final Notification status;
  final ReadNotificationModel? model;
  final String? message;

  NotificationState({
    this.status = Notification.initial,
    this.model,
    this.message,
  });

  NotificationState copyWith({
    Notification? status,
    ReadNotificationModel? model,
    String? message,
  }) {
    return NotificationState(
      status: status ?? this.status,
      model: model ?? this.model,
      message: message ?? this.message,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState());

  Future<void> markAsRead(String notificationKey) async {
    state = state.copyWith(status: Notification.loading);
    try {
      final result = await NotificationRepository.markNotificationAsRead(
        notificationKey,
      );
      if (result.status == 1) {
        state = state.copyWith(
          status: Notification.success,
          model: result,
          message: result.message,
        );
      } else {
        state = state.copyWith(
          status: Notification.error,
          message: result.message ?? 'Failed to mark notification as read',
          model: result,
        );
      }
    } catch (e) {
      state = state.copyWith(status: Notification.error, message: 'Error: $e');
    }
  }
}
