import 'package:flutter_background_service/flutter_background_service.dart';

class HandleBackgroundServices {
  Future<void> handleDetachedState() async {
    try {
      // Attempt to stop the background service and close the app
      FlutterBackgroundService().invoke('stop');
      print('App is detached, background service stopped');
    } catch (e) {
      print('Error handling detached state: $e');
    }
  }

  Future<void> handlePausedState() async {
    try {
      print('App is paused, background service paused');
    } catch (e) {
      print('Error handling paused state: $e');
    }
  }

  Future<void> handleInactiveState() async {
    try {
      // Handle the inactive state if needed
      print('App is inactive');
    } catch (e) {
      print('Error handling inactive state: $e');
    }
  }

  Future<void> handleResumedState() async {
    try {
      // Resume background service if needed

      print('App is resumed, background service resumed');
    } catch (e) {
      print('Error handling resumed state: $e');
    }
  }
}
