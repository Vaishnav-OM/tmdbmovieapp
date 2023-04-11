import 'package:flutter/material.dart';
import 'theme/appTheme.dart';
import 'homePage.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: HomePage(),
    );
  }
}
