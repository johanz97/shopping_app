import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xffFF8617);
  static const Color scaffoldBackgroundColor = Color(0xFFFFF4EF);
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFE76120);
  static const Color greyAccent = Color(0xff828282);
  static const Color grey = Color(0xffBDBDBD);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppTheme.primaryColor,
    primaryColorLight: AppTheme.backgroundColorLight,
    scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
    primaryColorDark: Colors.black,

    //indicadores de pantalla de bienvenida
    indicatorColor: const Color(0xFFC4C4C4),
    focusColor: const Color(0xFF9B9999),
    unselectedWidgetColor: AppTheme.grey,

    textTheme: lightTextTheme,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
  );

  static final TextTheme lightTextTheme = TextTheme(
    //Numeros de relog
    headline3: _headLine3Dark,

    //Saludo en welcome
    headline4: _headLine4Dark,

    //Titulo login
    headline5: _headLine5Light,

    //Titulo en page view en pagina de bienvenida
    headline6: _headLine6Light,

    //Descripcion en page view en pagina de bienvenida
    bodyText1: _bodyText1Light,

    //Eres nuevo en login page
    bodyText2: _bodyText2Light,

    //Utilizada en snackbar
    caption: _captionLight,

    //Boton con fondo dark
    subtitle1: _buttonDark,

    //Boton con fondo light
    subtitle2: _buttonLight,
  );

  static final TextStyle _headLine6Light = TextStyle(
    color: Colors.black,
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle _headLine5Light =
      _headLine6Light.copyWith(fontSize: 56.sp, fontWeight: FontWeight.bold);

  static final TextStyle _headLine4Dark = _headLine5Light.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 45.sp,
    color: Colors.black,
  );

  static final TextStyle _headLine3Dark = _headLine5Light.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 55.sp,
    color: Colors.black,
  );

  static final TextStyle _bodyText1Light = TextStyle(
    color: Colors.grey,
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final _bodyText2Light = _bodyText1Light.copyWith(fontSize: 26.sp);

  static final TextStyle _buttonDark = _headLine6Light.copyWith(
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontSize: 32.sp,
  );

  static final TextStyle _captionLight =
      _bodyText2Light.copyWith(color: AppTheme.grey);

  static final TextStyle _buttonLight = _buttonDark.copyWith(
    color: Colors.grey,
    fontSize: 28.sp,
  );
}
