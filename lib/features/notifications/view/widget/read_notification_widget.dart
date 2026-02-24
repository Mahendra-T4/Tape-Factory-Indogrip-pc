import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/notifications/model/notification_model.dart';
import 'package:indogrip/features/notifications/view/notification_responsive.dart';
import 'package:indogrip/features/notifications/view/provider/read_notification_provider.dart';

class ReadNotificationWidget extends ConsumerWidget {
  ReadNotificationWidget({
    super.key,
    required this.notification,
    this.onSuccess,
  });

  final Record notification;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(
      readNotificationProvider(notification.notificationKey.toString()),
    );

    return notificationState.status == Notification.loading
        ? SizedBox(
            width: 135,
            height: 40,
            child: Center(child: const CircularProgressIndicator()),
          )
        : ElevatedButton.icon(
            onPressed: () async {
              await ref
                  .read(
                    readNotificationProvider(
                      notification.notificationKey.toString(),
                    ).notifier,
                  )
                  .markAsRead(notification.notificationKey.toString());

              // Check the updated state after the notifier call
              final updatedState = ref.read(
                readNotificationProvider(
                  notification.notificationKey.toString(),
                ),
              );

              if (updatedState.status == Notification.success) {
                if (updatedState.model?.status == 1) {
                  if (!context.mounted) return;
                  ToastService.instance.showSuccess(
                    context,
                    updatedState.model!.message.toString(),
                  );
                  // Call the callback to refresh the parent list
                  onSuccess?.call();
                } else {
                  if (!context.mounted) return;
                  ToastService.instance.showError(
                    context,
                    updatedState.model!.message.toString(),
                  );
                }
              } else if (updatedState.status == Notification.error) {
                if (!context.mounted) return;
                ToastService.instance.showError(
                  context,
                  updatedState.message.toString(),
                );
              }
            },
            icon: const Icon(Icons.check, size: 16, color: Colors.white),
            label: const Text(
              'Mark as Read',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: kButtonColor,
            ),
          );
  }
}
