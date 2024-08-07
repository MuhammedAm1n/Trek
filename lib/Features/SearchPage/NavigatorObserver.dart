import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final VoidCallback onPop;

  MyNavigatorObserver({required this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onPop();
  }
}
