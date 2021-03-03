import 'package:ChuckyJokes/services/PushNotificationService.dart';
import 'package:ChuckyJokes/view/GetChuckCategories.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.configure(
        onBackgroundMessage: _backgroundMessageHandler
    );
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return MaterialApp(
      title: 'The Chuck Norris',
      home: GetChuckCategories()
    );
  }

  static Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: $data");
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: $notification");
    }
  }
}

