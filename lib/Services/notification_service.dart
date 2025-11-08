import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service for handling local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == false) {
        debugPrint('⚠️ Notification service: Platform initialization returned false');
        return;
      }

      // Request permissions for Android 13+
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;
      debugPrint('✅ Notification service initialized successfully');
    } catch (e) {
      debugPrint('❌ Notification service initialization error: $e');
      debugPrint('💡 Note: This may require a full app rebuild (not just hot reload)');
      debugPrint('💡 Try: Stop the app, run "flutter clean", then rebuild');
      // Don't set _initialized to true if initialization failed
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? true;
  }

  /// Show a notification for a new swap request
  Future<void> showSwapRequestNotification({
    required String requesterName,
    required String bookTitle,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ Notification service not initialized, skipping notification');
      return;
    }

    final enabled = await areNotificationsEnabled();
    if (!enabled) return;

    const androidDetails = AndroidNotificationDetails(
      'swap_requests',
      'Swap Requests',
      channelDescription: 'Notifications for book swap requests',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      'New Swap Request',
      '$requesterName wants to swap for "$bookTitle"',
      details,
    );
  }

  /// Show a notification for a new message
  Future<void> showMessageNotification({
    required String senderName,
    required String messageText,
    required String chatId,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ Notification service not initialized, skipping notification');
      return;
    }

    final enabled = await areNotificationsEnabled();
    if (!enabled) return;

    const androidDetails = AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      senderName,
      messageText,
      details,
      payload: chatId,
    );
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}

