import 'package:flutter/material.dart';
import 'package:news_c19/ui/screens/news/news_screen.dart';
import 'package:news_c19/ui/screens/splash/splash_screen.dart';
import 'package:news_c19/ui/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: NewsScreen(),
    );
  }
}



/// Request:
/// Type: GET - POST - PUT - DELETE - UPDATE...
/// Link: BaseUrl/Api{PathVariables}?QueryParameters
/// Body(Json - html - XML - )
/// Headers(Json)
///
/// Response:
/// Headers
/// Body
/// status code
///
