import 'package:flutter/material.dart';
import 'package:zstore/screens/home_screen.dart';
import 'database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DBHelper dbHelper = DBHelper();
  await dbHelper.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 GLOBAL SCROLL FIX
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoStretchScrollBehavior(),
          child: child!,
        );
      },

      home: HomeScreen(),
    );
  }
}

// 🔥 GLOBAL NO-STRETCH BEHAVIOR
class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return ClampingScrollPhysics();
  }
}
