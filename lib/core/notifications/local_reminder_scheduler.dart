import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../logging/debug_log.dart';
import 'reminder_scheduler.dart';
import 'task_notification_payload.dart';
import 'task_notification_identity_store.dart';

/// Android/iOS implementation of the reminder scheduling port.
///
/// The platform notification contains only the application identity and the
/// Task's own title. Document, analysis, and linked-record content never cross
/// this boundary.
class LocalReminderScheduler
    implements ReminderScheduler, ReminderPermissionReader {
  LocalReminderScheduler(
    this._identityStore, {
    FlutterLocalNotificationsPlugin? notifications,
  }) : _notifications = notifications ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'doxary_task_reminders';
  static const _channelName = 'Task reminders';

  final FlutterLocalNotificationsPlugin _notifications;
  final TaskNotificationIdentityStore _identityStore;
  Future<void>? _initializing;
  bool _permissionGrantedThisSession = false;
  void Function(String? payload)? _notificationResponseHandler;
  bool _responseHandlerInstalled = false;
  bool _collectingStartupResponses = false;
  final List<String?> _startupResponsePayloads = [];

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
    bool requestPermission = true,
  }) async {
    if (!_isSupported) {
      reminderDebugLog('scheduler', 'unsupported platform');
      return ReminderScheduleResult.unavailable;
    }
    try {
      reminderDebugLog('scheduler', 'schedule entered');
      await _initialize();
      final permissionFailure = await _permissionFailure(
        requestPermission: requestPermission,
      );
      if (permissionFailure != null) {
        reminderDebugLog('scheduler', 'permission ${permissionFailure.name}');
        return permissionFailure;
      }
      final notificationId = await _identityStore.resolve(taskId);
      reminderDebugLog('scheduler', 'scheduling future reminder');
      await _notifications.zonedSchedule(
        notificationId,
        'Doxary',
        taskTitle,
        tz.TZDateTime.from(at, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'Reminders for Doxary tasks',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: taskReminderPayload(taskId),
      );
      reminderDebugLog('scheduler', 'schedule result=success');
      return ReminderScheduleResult.scheduled;
    } catch (error) {
      reminderDebugLog(
        'scheduler',
        'schedule result=failure (${error.runtimeType})',
      );
      return ReminderScheduleResult.platformFailure;
    }
  }

  @override
  Future<ReminderScheduleResult> cancel(String taskId) async {
    if (!_isSupported) return ReminderScheduleResult.unavailable;
    try {
      await _initialize();
      final notificationId = await _identityStore.existing(taskId);
      if (notificationId == null) return ReminderScheduleResult.cancelled;
      await _notifications.cancel(notificationId);
      return ReminderScheduleResult.cancelled;
    } catch (_) {
      return ReminderScheduleResult.platformFailure;
    }
  }

  bool get _isSupported => Platform.isAndroid || Platform.isIOS;

  @override
  Future<ReminderPermissionStatus> readPermissionStatus() async {
    if (!_isSupported) return ReminderPermissionStatus.unavailable;
    try {
      if (Platform.isAndroid) {
        final android = _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final enabled = await android?.areNotificationsEnabled();
        return switch (enabled) {
          true => ReminderPermissionStatus.allowed,
          false => ReminderPermissionStatus.notAllowed,
          null => ReminderPermissionStatus.unavailable,
        };
      }
      final ios = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final settings = await ios?.checkPermissions();
      if (settings == null) return ReminderPermissionStatus.unavailable;
      return settings.isEnabled || settings.isProvisionalEnabled
          ? ReminderPermissionStatus.allowed
          : ReminderPermissionStatus.notAllowed;
    } catch (_) {
      return ReminderPermissionStatus.unavailable;
    }
  }

  /// Installs the foreground/background response callback and dispatches a
  /// notification that launched the process, if present.
  /// Navigation remains owned by the application layer.
  Future<void> initializeTaskNotificationResponses(
    void Function(String? payload) onResponse,
  ) async {
    if (!_isSupported) return;
    _notificationResponseHandler = onResponse;
    _collectingStartupResponses = true;
    _startupResponsePayloads.clear();
    var didLaunchFromNotification = false;
    String? launchPayload;
    try {
      await _initialize();
      if (!_responseHandlerInstalled) {
        final initialized = await _notifications.initialize(
          _initializationSettings,
          onDidReceiveNotificationResponse: _dispatchNotificationResponse,
        );
        if (initialized != true) {
          throw StateError(
            'Local notification response handler did not initialize.',
          );
        }
        _responseHandlerInstalled = true;
      }
      final launchDetails = await _notifications
          .getNotificationAppLaunchDetails();
      didLaunchFromNotification =
          launchDetails?.didNotificationLaunchApp == true;
      if (didLaunchFromNotification) {
        launchPayload = launchDetails?.notificationResponse?.payload;
      }
    } catch (error) {
      reminderDebugLog(
        'response',
        'notification response initialization failed (${error.runtimeType})',
      );
    } finally {
      _collectingStartupResponses = false;
      final payloads = <String?>[
        if (didLaunchFromNotification) launchPayload,
        ..._startupResponsePayloads,
      ];
      _startupResponsePayloads.clear();
      final uniquePayloads = <String?>[];
      for (final payload in payloads) {
        if (!uniquePayloads.contains(payload)) uniquePayloads.add(payload);
      }
      for (final payload in uniquePayloads) {
        _notificationResponseHandler?.call(payload);
      }
    }
  }

  void _dispatchNotificationResponse(NotificationResponse response) {
    if (_collectingStartupResponses) {
      _startupResponsePayloads.add(response.payload);
      return;
    }
    _notificationResponseHandler?.call(response.payload);
  }

  InitializationSettings get _initializationSettings =>
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );

  Future<void> _initialize() async {
    final existing = _initializing;
    if (existing != null) {
      reminderDebugLog('scheduler', 'using existing initialization');
      return existing;
    }
    final initializing = _initializeOnce();
    _initializing = initializing;
    try {
      await initializing;
    } catch (_) {
      if (identical(_initializing, initializing)) {
        _initializing = null;
      }
      rethrow;
    }
  }

  Future<void> _initializeOnce() async {
    reminderDebugLog('scheduler', 'initialization started');
    tz.initializeTimeZones();
    final deviceZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(deviceZone.identifier));
    final initialized = await _notifications.initialize(
      _initializationSettings,
      onDidReceiveNotificationResponse: _notificationResponseHandler == null
          ? null
          : _dispatchNotificationResponse,
    );
    if (initialized != true) {
      throw StateError('Local notifications did not initialize.');
    }
    _responseHandlerInstalled = _notificationResponseHandler != null;
    reminderDebugLog('scheduler', 'initialized');
  }

  Future<ReminderScheduleResult?> _permissionFailure({
    required bool requestPermission,
  }) async {
    // Normal scheduling follows the existing contextual request policy. Bulk
    // reconciliation from Settings reads permission and never prompts.
    if (requestPermission && _permissionGrantedThisSession) {
      reminderDebugLog('permission', 'using granted session permission');
      return null;
    }
    final status = await readPermissionStatus();
    if (status == ReminderPermissionStatus.allowed) {
      _permissionGrantedThisSession = true;
      return null;
    }
    if (!requestPermission) {
      return status == ReminderPermissionStatus.notAllowed
          ? ReminderScheduleResult.permissionDenied
          : ReminderScheduleResult.unavailable;
    }
    if (Platform.isAndroid) {
      final android = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android == null) {
        reminderDebugLog(
          'permission',
          'Android plugin implementation unavailable',
        );
        return ReminderScheduleResult.unavailable;
      }
      reminderDebugLog('permission', 'Android plugin implementation resolved');
      reminderDebugLog(
        'permission',
        'requesting Android notification permission',
      );
      final granted = await android.requestNotificationsPermission();
      final accepted = granted == true;
      final result = switch (granted) {
        true => 'granted',
        false => 'denied',
        null => 'unavailable',
      };
      reminderDebugLog('permission', 'Android permission result=$result');
      _permissionGrantedThisSession = accepted;
      return accepted ? null : ReminderScheduleResult.permissionDenied;
    }
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios == null) return ReminderScheduleResult.unavailable;
    final granted =
        await ios.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
    _permissionGrantedThisSession = granted;
    reminderDebugLog(
      'permission',
      'iOS permission result=${granted ? 'granted' : 'denied'}',
    );
    return granted ? null : ReminderScheduleResult.permissionDenied;
  }
}
