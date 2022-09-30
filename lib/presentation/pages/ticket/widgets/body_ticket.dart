import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../aplication/ticket/ticket_watcher_bloc/ticket_watcher_bloc.dart';
import '../../../../core/utils.dart';
import '../../../../domain/ticket/ticket_status/ticket_status.dart';
import 'clock_figure.dart';
import 'date_hour.dart';
import 'table_values.dart';
import 'time_watcher.dart';

class BodyTicket extends StatelessWidget {
  final TicketStatus ticket;
  const BodyTicket({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nowUTC = getNow();
    final currentDate = nowUTC.difference(ticket.entraceDate);
    final gracePeriod = getServerDate(ticket.gracePeriodMaxTime.toLocal());
    final getExitAllowed = getServerDate(ticket.exitAllowedDate!.toLocal());
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30.h),
      constraints: const BoxConstraints(minHeight: 200),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Date(
            date: DateFormat.yMMMMd('pt').format(ticket.entraceDate),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hour(
                hour: DateFormat.Hm().format(ticket.entraceDate),
              ),
              Hour(
                onStart: false,
                hour: DateFormat.Hm().format(ticket.getExitAllowedDateTime!),
              )
            ],
          ),
          const ClockFigure(),
          Visibility(
            visible: ticket.needsPayment,
            child: TimeWatcher(
              mode: StopWatchMode.countUp,
              start: currentDate,
            ),
          ),
          Visibility(
            visible: ticket.isPaid,
            child: CountdownTimer(
              endTime: getExitAllowed.millisecondsSinceEpoch,
              onEnd: () => context
                  .read<TicketWatcherBloc>()
                  .add(TicketWatcherEvent.finishFreeTime(ticket.ticketId)),
              widgetBuilder: (_, time) {
                if (time == null) {
                  return Container();
                }
                return FreeTimeWatcher(
                  time: time,
                );
              },
            ),
          ),
          Visibility(
            visible: ticket.isInGracePeriod,
            child: CountdownTimer(
              endTime: gracePeriod.millisecondsSinceEpoch,
              onEnd: () => context
                  .read<TicketWatcherBloc>()
                  .add(TicketWatcherEvent.finishFreeTime(ticket.ticketId)),
              widgetBuilder: (_, time) {
                if (time == null) {
                  return Container();
                }
                return FreeTimeWatcher(
                  time: time,
                );
              },
            ),
          ),
          Visibility(
            visible: ticket.isPaid,
            child: SvgPicture.asset(
              'assets/svg/line.svg',
              height: 20.h,
              width: 200,
            ),
          ),
          Visibility(
            visible: ticket.isFree || ticket.isInGracePeriod,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0.h, bottom: 20.h),
              child: Text(
                'TicketNotPaidStatusWidget.status_2'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.green),
              ),
            ),
          ),
          Visibility(
            visible: ticket.needsPayment && !ticket.isInGracePeriod,
            child: TableValues(
              ticket: ticket,
            ),
          ),
          Visibility(
            visible: ticket.isPaid || ticket.hasExited,
            child: StatusBanner(
              hasExited: ticket.hasExited,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool hasExited;
  const StatusBanner({
    Key? key,
    required this.hasExited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      height: 40,
      width: 250,
      decoration: BoxDecoration(
        color: hasExited ? Colors.red : const Color(0xFF05E300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          !hasExited
              ? 'TicketNotPaidStatusWidget.status_1'.tr()
              : 'TicketNotPaidStatusWidget.status_3'.tr(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

class FreeTimeWatcher extends StatelessWidget {
  final CurrentRemainingTime time;
  const FreeTimeWatcher({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(
              flex: 2,
            ),
            if (time.hours != null)
              Text(
                '${time.hours} h',
                style: Theme.of(context).textTheme.headline4,
              ),
            Visibility(
              visible: time.hours != null,
              child: SizedBox(
                width: 20.w,
              ),
            ),
            if (time.min != null)
              Text(
                '${time.min} m',
                style: Theme.of(context).textTheme.headline4,
              ),
            Visibility(visible: time.min != null, child: SizedBox(width: 20.w)),
            Text(
              '${time.sec} s',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ],
    );
  }
}
