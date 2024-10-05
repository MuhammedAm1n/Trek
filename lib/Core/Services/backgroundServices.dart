import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FlutterBackgroundService? _backgroundService;

Future<void> initializeService() async {
  if (_backgroundService != null) return; // Already initialized

  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false, // Do not show initial notification
      autoStart: true,
      initialNotificationTitle: '', // Empty title for initial notification
      initialNotificationContent: '', // Empty content for initial notification
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
  _backgroundService = service;
}

bool onIosBackground(ServiceInstance service) {
  return true; // Ensures the service keeps running when the app is backgrounded on iOS
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Configure local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Dictionary to store timer and elapsed time for each taskId
  final Map<String, Timer> timers = {};
  final Map<String, int> elapsedTimes = {};
  String? currentTaskId;

  String convertingMintoSec(int totalSeconds) {
    int sec = totalSeconds % 60;
    int min =
        totalSeconds ~/ 60; // Use integer division to get the number of minutes

    // Format seconds to always be two digits
    String secStr = sec.toString().padLeft(2, '0');
    return '$min:$secStr';
  }

  // Pause all running tasks
  void pauseAllTasks() {
    for (var taskId in timers.keys) {
      final timer = timers[taskId];
      if (timer != null) {
        timer.cancel(); // Pause the timer
        final elapsedTime = elapsedTimes[taskId] ?? 0;

        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "Trek Timer",
            content:
                "Task $taskId is paused: ${convertingMintoSec(elapsedTime)}",
          );
        }
      }
    }
  }

  // Handle start event
  service.on('start').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();
    final startTimeString = event['startTime'] as String?;
    final startTime =
        startTimeString != null ? DateTime.tryParse(startTimeString) : null;
    final elapsedTime = event['elapsedTime'] as int? ?? 0;

    if (taskId == null || startTime == null) {
      return;
    }

    // Pause all existing tasks before starting a new one
    if (currentTaskId != null && currentTaskId != taskId) {
      pauseAllTasks();
    }

    // Start or resume the timer
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        // Calculate total elapsed time from startTime and the time already spent
        final currentTime = DateTime.now();
        final elapsedSinceStart = currentTime.difference(startTime).inSeconds;
        final totalElapsed = elapsedTime + elapsedSinceStart;

        await flutterLocalNotificationsPlugin.show(
          1, // Unique ID for the timer notification
          'Trek Timer',
          "Task $habitName is running: ${convertingMintoSec(totalElapsed)}",
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'your_channel_id', 'your_channel_name',
                channelDescription: 'Timer notification',
                importance: Importance.low, // Low importance to avoid pop-ups
                priority: Priority.low, // Low priority to avoid pop-ups
                showWhen: true,
                sound: null,
                icon: "icondrwable"
                // Mute sound
                ),
          ),
        );

        await (service).setForegroundNotificationInfo(
          title: "Trek Timer",
          content:
              "Task $habitName is running: ${convertingMintoSec(totalElapsed)}",
        );

        // Update elapsed time
        elapsedTimes[taskId] = totalElapsed;
        service.invoke('update', {"taskId": taskId, "seconds": totalElapsed});
      }
    });

    timers[taskId] = timer;
    currentTaskId = taskId; // Update the current task ID
  });

  // Handle pause event
  service.on('pause').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();
    final startTimeString = event['startTime'] as String?;
    final startTime =
        startTimeString != null ? DateTime.tryParse(startTimeString) : null;
    final elapsedTime = event['elapsedTime'] as int? ?? 0;

    if (taskId != null && startTime != null) {
      final currentTime = DateTime.now();
      final elapsedSinceStart = currentTime.difference(startTime).inSeconds;
      final totalElapsed = elapsedTime + elapsedSinceStart;

      final timer = timers[taskId];
      if (timer != null) {
        timer.cancel(); // Pause the timer
        if (service is AndroidServiceInstance) {
          await flutterLocalNotificationsPlugin.show(
            1, // Unique ID for the timer notification
            'Trek Timer',
            "Task $habitName is paused: ${convertingMintoSec(totalElapsed)}",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your_channel_id', 'your_channel_name',
                  channelDescription: 'Timer notification',
                  importance: Importance.low, // Low importance to avoid pop-ups
                  priority: Priority.low, // Low priority to avoid pop-ups
                  showWhen: true,
                  sound: null,
                  icon: "icondrwable"
                  // Mute sound
                  ),
            ),
          );
        }
      }
    }
  });

  // Handle resume event
  service.on('resume').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();
    final startTimeString = event['startTime'] as String?;
    final startTime =
        startTimeString != null ? DateTime.tryParse(startTimeString) : null;
    final elapsedTime = event['elapsedTime'] as int? ?? 0;

    if (taskId != null && startTime != null) {
      // Resume the timer
      Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (service is AndroidServiceInstance) {
          // Calculate total elapsed time from startTime and the time already spent
          final currentTime = DateTime.now();
          final elapsedSinceStart = currentTime.difference(startTime).inSeconds;
          final totalElapsed = elapsedTime + elapsedSinceStart;

          await flutterLocalNotificationsPlugin.show(
            1, // Unique ID for the timer notification
            'Trek Timer',
            "Task $habitName is running: ${convertingMintoSec(totalElapsed)}",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'your_channel_id',
                'your_channel_name',
                channelDescription: 'Timer notification',
                importance: Importance.low, // Low importance to avoid pop-ups
                priority: Priority.low, // Low priority to avoid pop-ups
                showWhen: true,
                icon: "icondrwable",
                sound: null, // Mute sound
              ),
            ),
          );

          // Update elapsed time
          elapsedTimes[taskId] = totalElapsed;
          service.invoke('update', {"taskId": taskId, "seconds": totalElapsed});
        }
      });

      timers[taskId] = timer; // Resume or start the timer
    }
  });

  // Handle delete event
  service.on('delete').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();

    if (taskId != null) {
      final timer = timers[taskId];
      if (timer != null) {
        timer.cancel(); // Delete the timer
        timers.remove(taskId); // Remove the timer from the map
        elapsedTimes.remove(taskId); // Remove the elapsed time entry

        if (service is AndroidServiceInstance) {
          await flutterLocalNotificationsPlugin.show(
            1, // Unique ID for the timer notification
            'Trek Timer',
            "Task $habitName has been deleted",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'your_channel_id',
                'your_channel_name',
                channelDescription: 'Timer notification',
                importance: Importance.low, // Low importance to avoid pop-ups
                priority: Priority.low, // Low priority to avoid pop-ups
                showWhen: true,
                icon: "icondrwable",
                sound: null, // Mute sound
              ),
            ),
          );
        }
      }
    }
  });

  // Handle delete event
  service.on('update').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();

    if (taskId != null) {
      final timer = timers[taskId];
      if (timer != null) {
        timer.cancel(); // Delete the timer
        timers.remove(taskId); // Remove the timer from the map
        elapsedTimes.remove(taskId); // Remove the elapsed time entry

        if (service is AndroidServiceInstance) {
          await flutterLocalNotificationsPlugin.show(
            1, // Unique ID for the timer notification
            'Trek Timer',
            "Task $habitName is paused",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'your_channel_id',
                'your_channel_name',
                channelDescription: 'Timer notification',
                importance: Importance.low, // Low importance to avoid pop-ups
                priority: Priority.low, // Low priority to avoid pop-ups
                showWhen: true,
                icon: "icondrwable",
                sound: null, // Mute sound
              ),
            ),
          );
        }
      }
    }
  });

  // Handle finish event
  service.on('finish').listen((event) async {
    try {
      // Stop all running timers
      for (var timer in timers.values) {
        timer.cancel();
      }
      timers.clear(); // Clear the timer map to avoid future issues

      if (service is AndroidServiceInstance) {
        await flutterLocalNotificationsPlugin.show(
          1, // Unique ID for the timer notification
          'Trek Timer',
          "Yay, your task is over!",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              icon: "icondrwable",
              channelDescription: 'Timer notification',
              importance: Importance.low, // Low importance to avoid pop-ups
              priority: Priority.low, // Low priority to avoid pop-ups
              showWhen: true,
              sound: null, // Mute sound
            ),
          ),
        );
      }

      // Log the service stop
    } catch (e) {}
  });

  // Handle stop event
  service.on('stop').listen((event) async {
    try {
      // Stop all running timers
      for (var timer in timers.values) {
        timer.cancel();
      }
      timers.clear(); // Clear the timer map to avoid future issues
      elapsedTimes.clear(); // Clear elapsed times

      if (service is AndroidServiceInstance) {
        service.stopSelf();
      }
    } finally {
      // Ensure the background service is stopped
      service.stopSelf();
    }
  });

  // Hide initial notification after a short delay
  Future.delayed(const Duration(seconds: 1), () async {
    await flutterLocalNotificationsPlugin
        .cancel(0); // Cancel the placeholder notification
  });
}
