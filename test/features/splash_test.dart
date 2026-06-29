// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_see_splash_screen.dart';

void main() {
  group('''Splash Screen Loading''', () {
    testWidgets('''First time app load shows splash screen''', (tester) async {
      await theAppIsRunning(tester);
      await iSeeSplashScreen(tester);
    });
  });
}
