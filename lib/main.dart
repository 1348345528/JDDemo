import 'package:flutter/material.dart';
import 'package:flutter_jd/routes/Routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        designSize: Size(360, 690),
        builder:()=> MaterialApp(
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
        )
    );
  }
}
