import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audio_service/audio_service.dart';
import '../models/video.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Bildirime tıklandığında yapılacak işlemler
        _handleNotificationTap(response.payload);
      },
    );

    // Bildirim kanalını oluştur
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'music_playback',
      'Music Playback',
      description: 'Notifications for music playback controls',
      importance: Importance.high,
      enableVibration: false,
      showBadge: false,
      playSound: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> showMusicNotification({
    required Video video,
    required bool isPlaying,
    required Duration duration,
    required Duration position,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'music_playback',
      'Music Playback',
      channelDescription: 'Notifications for music playback controls',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      enableVibration: false,
      playSound: false,
      showWhen: false,
      largeIcon: FilePathAndroidBitmap(video.thumbnail),
      category: AndroidNotificationCategory.transport,
      actions: [
        if (isPlaying)
          const AndroidNotificationAction('pause', 'Pause', icon: 'pause')
        else
          const AndroidNotificationAction('play', 'Play', icon: 'play'),
        const AndroidNotificationAction('next', 'Next', icon: 'skip_next'),
        const AndroidNotificationAction('stop', 'Stop', icon: 'stop'),
      ],
    );

    await _notificationsPlugin.show(
      0,
      video.title,
      video.channelTitle,
      NotificationDetails(android: androidDetails),
      payload: video.id,
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      // Video oynatma ekranına yönlendir
    }
  }

  Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(0);
  }
}
