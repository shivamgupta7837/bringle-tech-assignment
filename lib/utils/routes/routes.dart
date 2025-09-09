import 'package:flutter/material.dart';
import 'package:face_filter/presentation/screens/splash_screen.dart';

class AppRoutes{
  static final String splashScreen = "/splashScreen";
 

  static Map<String, Widget Function(BuildContext)> routes= {
      splashScreen: (context) =>  SplashScreen(),
  };
}