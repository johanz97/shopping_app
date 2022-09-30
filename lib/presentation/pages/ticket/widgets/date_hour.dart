import 'package:flutter/material.dart';

class Hour extends StatelessWidget {
  final bool onStart;
  final String hour;
  const Hour({
    Key? key,
    required this.hour,
    this.onStart = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          onStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          hour,
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

class Date extends StatelessWidget {
  final String date;
  const Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
