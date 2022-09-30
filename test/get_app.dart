import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parking_web_app_maicero_shop/presentation/core/theme_data.dart';

Widget getApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(750, 1334),
    builder: () {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
        title: 'Parking App',
        theme: AppTheme.lightTheme,
      );
    },
  );
}
