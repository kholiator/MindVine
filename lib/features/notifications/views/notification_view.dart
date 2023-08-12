/*The purpose of each import statement is commented to explain its role.
The NotificationView class is a ConsumerWidget that displays the notifications for the current user.
The currentUser is obtained using ref.watch(currentUserDetailsProvider).value.
The Scaffold widget is used to create the UI for the notification view.
The AppBar displays the title and a close button that navigates back to the home view.
The body of the Scaffold is conditionally rendered based on the currentUser value.
The getNotificationsProvider and getLatestNotificationProvider are used to retrieve the notifications and the latest notification, respectively.
The notifications are rendered in a ListView.builder using the NotificationTile widget for each notification item.
The when method is used to handle the different states of the getNotificationsProvider and getLatestNotificationProvider providers and display the appropriate UI (loading, error, or data).*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvine/features/home/view/home_view.dart';
import 'package:mindvine/models/notification_model.dart' as model;
import 'package:mindvine/common/common.dart';
import 'package:mindvine/constants/appwrite_constants.dart';
import 'package:mindvine/features/auth/controller/auth_controller.dart';
import 'package:mindvine/features/notifications/controller/notification_controller.dart';
import 'package:mindvine/features/notifications/widget/notification_tile.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
            );
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create',
                          )) {
                            final latestNotif =
                                model.Notification.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                          }

                          return ListView.builder(
                            key: key,
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
