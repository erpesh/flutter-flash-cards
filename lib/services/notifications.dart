import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flash_cards/pages/test_history.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NotificationServices {
  static Future<void> initialiseNotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: "main_channel",
        channelName: "Main Channel",
        channelDescription: "Main Channel of the Flash Cards app",
        channelGroupKey: "mc_group",
        importance: NotificationImportance.Max,
        playSound: true,
        criticalAlerts: true,
        onlyAlertOnce: true,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "mc_group",
        channelGroupName: "Main Channel Group"
      )
    ],
    debug: true);
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const TestHistoryPage())
      );
    }
  }
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    print("Notification created");
  }
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    print("Notification displayed");
  }
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    print("Dismiss Action received");
  }

  static Future<void> displayNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval
  }) async {
    assert(!scheduled || interval != null);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: "main_channel",
        title: title,
        body: body,
        summary: summary,
        payload: payload,
        actionType: actionType,
        notificationLayout: notificationLayout,
        category: category,
        bigPicture: bigPicture
      ),
      actionButtons: actionButtons,
      schedule: scheduled ? NotificationInterval(
        interval: interval,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
      ) : null
    );
  }
}