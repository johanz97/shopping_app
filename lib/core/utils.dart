import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

class Utils {
  const Utils();
  static String generateId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static DateTime fromUSADateToDateTime(String date) {
    initializeDateFormatting('en_US');
    final englishDateParser = DateFormat("yyyy-MM-dd");
    return englishDateParser.parse(date);
  }
}

extension ToLocalDate on DateTime {
  DateTime toLocalDate() {
    final maceio = tz.getLocation('America/Maceio');
    final date = tz.TZDateTime.from(this, maceio);
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
    );
  }
}

void showSnackBarError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      content: Text(message),
    ),
  );
}

void showSnackBarSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.white,
            ),
      ),
    ),
  );
}

int formatPhoneInt(String phone) {
  final String ddd = phone.length > 3 ? phone.substring(1, 3) : "";
  final String part1 = phone.length > 10 ? phone.substring(5, 10) : "";
  final String part2 = phone.length > 14 ? phone.substring(11, 14) : "";

  final numberStr = ddd + part1 + part2;
  return numberStr.isNotEmpty ? int.parse(numberStr) : 0;
}

int random(int min, int max) {
  final rn = Random();
  return min + rn.nextInt(max - min);
}

Future<Tuple2<T1, T2>> waitConcurrently<T1, T2>(
  Future<T1> future1,
  Future<T2> future2,
) async {
  late T1 result1;
  late T2 result2;

  await Future.wait([
    future1.then((value) => result1 = value),
    future2.then((value) => result2 = value)
  ]);

  return Future.value(Tuple2(result1, result2));
}

DateTime getNow() {
  final now = TZDateTime.from(DateTime.now(), getLocation('America/Maceio'));
  return DateTime.utc(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
}

DateTime getServerDate(DateTime date) {
  final timeZoneMaceio =
      TZDateTime.now(getLocation('America/Maceio')).timeZoneOffset.abs();
  return DateTime(
    date.year,
    date.month,
    date.day,
    date.hour + timeZoneMaceio.inHours,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}
