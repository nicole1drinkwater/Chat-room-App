import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future init () async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

    static Future<String?> getFCMToken({int maxRetries = 3}) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      
      if (maxRetries > 0) {
        await Future.delayed(const Duration(seconds: 10));
        return getFCMToken(maxRetries: maxRetries - 1);
      } else {
        return null;
      }
    }
  }

}