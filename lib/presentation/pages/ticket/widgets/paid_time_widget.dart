import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaidTimeWidget extends StatelessWidget {
  final Duration paidTime;
  const PaidTimeWidget({Key? key, required this.paidTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display =
        DateTime.fromMillisecondsSinceEpoch(paidTime.inMilliseconds);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          DateFormat.Hms().format(display),
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
