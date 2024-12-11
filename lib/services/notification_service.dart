import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/video.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> showMusicNotification(Video video, bool isPlaying) async {
    const androidDetails = AndroidNotificationDetails(
      'music_channel',
      'Music Playback',
      channelDescription: 'Controls for currently playing music',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: false,
      enableVibration: false,
      playSound: false,
      onlyAlertOnce: true,
    );

    await _notifications.show(
      0,
      video.title,
      video.channelTitle,
      NotificationDetails(android: androidDetails),
      payload: video.id,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Bildirime tıklandığında yapılacak işlemler
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
