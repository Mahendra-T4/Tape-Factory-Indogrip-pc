import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/notifications/model/notification_model.dart';
import 'package:indogrip/features/notifications/model/notification_status_model.dart';
import 'package:indogrip/features/notifications/model/read_notification_model.dart';
import 'package:retry/retry.dart';

// final notificationProvider = FutureProvider(
//   (ref) => NotificationRepository.fetchNotifications(),
// );

class NotificationRepository {
  static Future<NotificationModel> fetchNotifications(filterBy) async {
    NotificationModel notificationModel = NotificationModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'admin-notification',
                'userKey': HiveService.getUserId(),
                'filterBy': filterBy.toString(),
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(response.data);
        developer.log(
          'Notifications fetched successfully: ${notificationModel.message}',
          name: 'Fetch Notifications',
        );
      } else {
        developer.log(
          'Failed to fetch notifications',
          name: 'Fetch Notifications',
        );
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'Fetch Notifications');
    } catch (e) {
      print(e);
    }
    return notificationModel;
  }

  static Future<ReadNotificationModel> markNotificationAsRead(
    String notificationKey,
  ) async {
    ReadNotificationModel readNotificationModel = ReadNotificationModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'read-notification',
                'userKey': HiveService.getUserId(),
                'notificationKey': notificationKey,
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        readNotificationModel = ReadNotificationModel.fromJson(response.data);
        developer.log(
          readNotificationModel.message.toString(),
          name: 'Mark Notification as Read Success',
        );
        return readNotificationModel;
      } else {
        developer.log(
          'Failed to mark notification as read - Status: ${response.statusCode}',
          name: 'Mark Notification as Read',
        );
        readNotificationModel = ReadNotificationModel(
          status: 0,
          message: 'Failed to mark notification as read',
        );
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'Mark Notification as Read');
      readNotificationModel = ReadNotificationModel(
        status: 0,
        message: 'Error: ${e.message}',
      );
    } catch (e) {
      developer.log('Error: $e', name: 'Mark Notification as Read');
      readNotificationModel = ReadNotificationModel(
        status: 0,
        message: 'Error: $e',
      );
    }
    return readNotificationModel;
  }

  static Future<ReadUnReadMasterStatusModel> readUnreadMasterStatus() async {
    ReadUnReadMasterStatusModel notificationModel =
        ReadUnReadMasterStatusModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-read-unread-status',
                'userKey': HiveService.getUserId(),
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        notificationModel = ReadUnReadMasterStatusModel.fromJson(response.data);
        developer.log(
          'Notifications Status fetched successfully: ${notificationModel.message}',
          name: 'Fetch Notifications Status',
        );
      } else {
        developer.log(
          'Failed to fetch notifications status',
          name: 'Fetch Notifications Status Failed',
        );
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'Fetch Notifications');
    } catch (e) {
      print(e);
    }
    return notificationModel;
  }
}
