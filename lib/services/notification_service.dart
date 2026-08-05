import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'hive_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static const String _prefKey = 'notifications_enabled';

  /// Returns whether local tray notifications are enabled in app settings.
  static bool get notificationsEnabled {
    if (!HiveService.isSettingsBoxOpen) return true;
    return HiveService.settingsBox.get(_prefKey, defaultValue: true) as bool;
  }

  /// Sets notification preferences in Hive local storage.
  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (HiveService.isSettingsBoxOpen) {
      await HiveService.settingsBox.put(_prefKey, enabled);
    }
    if (enabled && !_initialized) {
      await init();
    }
  }

  /// Initializes the local notification plugin and configures the Android notification channel.
  static Future<void> init() async {
    if (_initialized) return;
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);

      await _plugin.initialize(initSettings);

      const androidChannel = AndroidNotificationChannel(
        'buildmate_channel',
        'BuildMate Notifications',
        description: 'Local notifications for BuildMate estimates and reports',
        importance: Importance.high,
      );

      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(androidChannel);
        // Request runtime permission on Android 13+
        await androidImplementation.requestNotificationsPermission();
      }

      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  /// Displays a local notification in the phone's tray if notifications are enabled.
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (!notificationsEnabled) return;

    if (!_initialized) {
      await init();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'buildmate_channel',
        'BuildMate Notifications',
        channelDescription: 'Local notifications for BuildMate estimates and reports',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails = NotificationDetails(android: androidDetails);
      final id = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

      await _plugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('NotificationService showNotification error: $e');
    }
  }
}
