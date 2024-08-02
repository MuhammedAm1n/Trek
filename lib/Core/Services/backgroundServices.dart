import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
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

  convertingMintoSec(int totalSeconds) {
    String sec = (totalSeconds % 60).toString();
    String min = (totalSeconds / 60).toStringAsFixed(2);

    // if sec is a 1 digit number , place a 0 infornt of it
    if (sec.length == 1) {
      sec = '0$sec';
    }

    // if min is a 1 digit number
    if (min[1] == ".") {
      min = min.substring(0, 1);
    }
    return '$min : $sec';
  }

// Handle start event
  service.on('start').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();
    final startTimeString = event['startTime'] as String;
    final startTime = DateTime.tryParse(startTimeString);
    final elapsedTime = event['elapsedTime'] as int? ?? 0;

    if (taskId == null || startTime == null) {
      return;
    }

    // Start or resume the timer
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        // Calculate total elapsed time from startTime and the time already spent
        final currentTime = DateTime.now();
        final elapsedSinceStart = currentTime.difference(startTime).inSeconds;
        final totalElapsed = elapsedTime + elapsedSinceStart;

        await (service as AndroidServiceInstance).setForegroundNotificationInfo(
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
  });

// Handle pause event
  service.on('pause').listen((event) async {
    final taskId = event!['taskId']?.toString();
    final habitName = event['habitName']?.toString();
    final startTimeString = event['startTime'] as String;
    final startTime = DateTime.tryParse(startTimeString);
    final elapsedTime = event['elapsedTime'] as int? ?? 0;

    final currentTime = DateTime.now();
    final elapsedSinceStart = currentTime.difference(startTime!).inSeconds;
    final totalElapsed = elapsedTime + elapsedSinceStart;

    if (taskId != null) {
      final timer = timers[taskId];
      if (timer != null) {
        timer.cancel(); // Pause the timer
        if (service is AndroidServiceInstance) {
          await (service).setForegroundNotificationInfo(
            title: "Trek Timer",
            content:
                "Task $habitName is paused : ${convertingMintoSec(totalElapsed)}",
          );
        }
      }
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
          await (service).setForegroundNotificationInfo(
            title: "Trek Timer",
            content: "Task $habitName has been deleted",
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
        await (service as AndroidServiceInstance).setForegroundNotificationInfo(
          title: "Trek Timer",
          content: "Yay, your task is over!",
        );
      }

      // Log the service stop
      print('Background service has been stopped.');
    } catch (e) {
      print('Error stopping the service: $e');
    }
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
        await (service).setForegroundNotificationInfo(
          title: "Trek Timer",
          content: "Service is stopping, all timers cleared",
        );
        service.stopSelf();
      }

      service.stopSelf();
    } finally {
      // Ensure the background service is stopped
      service.stopSelf();
    }
  });
}
