import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimeWatcher extends StatefulWidget {
  final StopWatchMode mode;
  final Duration start;

  const TimeWatcher({
    Key? key,
    required this.mode,
    required this.start,
  }) : super(key: key);

  @override
  _TimeWatcherState createState() => _TimeWatcherState();
}

class _TimeWatcherState extends State<TimeWatcher> {
  late StopWatchTimer _stopWatchTimer = StopWatchTimer();
  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer(
      mode: widget.mode,
      presetMillisecond: widget.start.inMilliseconds,
    );
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!;
        final display = StopWatchTimer.getDisplayTime(
          value,
          milliSecond: false,
        );
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  display,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
