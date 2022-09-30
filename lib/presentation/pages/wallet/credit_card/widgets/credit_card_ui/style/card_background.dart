import 'package:flutter/material.dart';

class CardBackgrounds {
  CardBackgrounds._();

  static Widget black = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: const Color(0xff0B0B0F),
  );

  static Widget white = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: const Color(0xffF9F9FA),
  );

  static Widget grey = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Colors.grey,
  );
  static Widget red = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Colors.red,
  );
  static Widget orange = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xffFF5F6D),
          Color(0xFFFFC371),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
  static Widget blue = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Colors.blue,
  );
  static Widget green = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Colors.greenAccent,
  );
  static Widget grad1 = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xff12c2e9),
          Color(0xFFc471ed),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );

  static Widget grad2 = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xff00B4DB),
          Color(0xFF0083B0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
  static Widget grad3 = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xffFEAC5E),
          Color(0xFFC779D0),
          Color(0xFF4BC0C8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
  static Widget grad4 = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xff0f0c29),
          Color(0xFF302b63),
          Color(0xFF24243e),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );

  static Widget getAnyColor(int index) {
    final list = [
      black,
      white,
      grey,
      red,
      orange,
      blue,
      green,
      grad1,
      grad2,
      grad3,
      grad4
    ];
    return list[index];
  }
}
