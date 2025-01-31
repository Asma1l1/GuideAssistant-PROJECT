import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/notification_model.dart';
import 'package:muieen_project/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          final notification = NotificationModel(
            title: message.notification!.title!,
            body: message.notification!.body!,
          );

          // Add notification to the provider
          Provider.of<NotificationProvider>(context, listen: false)
              .addNotification(notification);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          final notification = NotificationModel(
            title: message.notification!.title!,
            body: message.notification!.body!,
          );

          // Add notification to the provider
          Provider.of<NotificationProvider>(context, listen: false)
              .addNotification(notification);
        }
      });
    }
  }
}
