import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../domain/ticket/ticket.dart';
import '../../../../../domain/ticket/ticket_status/ticket_status.dart';
import 'empty_list_indicator.dart';

class TicketDetailsModal extends StatelessWidget {
  final Ticket ticket;
  const TicketDetailsModal({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat('##0.00#');
    return Container(
      height: 0.5.sh,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 50.w,
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(
                    text: "tickets_archive_page.details_modal.title_1"
                        .tr(args: [ticket.states!.length.toString()]),
                  ),
                  Tab(
                    text: "tickets_archive_page.details_modal.title_2"
                        .tr(args: [ticket.payments!.length.toString()]),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    if (ticket.states!.isEmpty)
                      EmptyListIndicator(
                        icon: Icons.info,
                        message: "tickets_archive_page.details_modal.subtitle_1"
                            .tr(),
                      )
                    else
                      ListView.builder(
                        itemCount: ticket.states!.length,
                        itemBuilder: (context, index) {
                          return TimelineTile(
                            isFirst: index == 0,
                            isLast: index == (ticket.states!.length - 1),
                            endChild: ListTile(
                              title: Text(
                                "${ticket.states![index].state.toStr}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(DateFormat.HOUR24_MINUTE, "pt_BR")
                                    .format(ticket.states![index].at),
                              ),
                            ),
                            indicatorStyle: IndicatorStyle(
                              height: 30,
                              width: 30,
                              color: Theme.of(context).primaryColor,
                              iconStyle: IconStyle(
                                fontSize: 20,
                                color: Colors.white,
                                iconData: getIcon(ticket.states![index].state)!,
                              ),
                            ),
                          );
                        },
                      ),
                    if (ticket.payments!.isEmpty)
                      EmptyListIndicator(
                        icon: Icons.info,
                        message: "tickets_archive_page.details_modal.subtitle_2"
                            .tr(),
                      )
                    else
                      ListView.builder(
                        itemCount: ticket.payments!.length,
                        itemBuilder: (context, index) {
                          return TimelineTile(
                            isFirst: index == 0,
                            isLast: index == (ticket.payments!.length - 1),
                            endChild: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    'R\$ ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  Text(
                                    f.format(
                                      ticket.payments![index].total,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          fontSize: 30.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                DateFormat(
                                  DateFormat.HOUR24_MINUTE,
                                  "pt_BR",
                                ).format(
                                  ticket.states![index].at,
                                ),
                              ),
                            ),
                            indicatorStyle: IndicatorStyle(
                              height: 30,
                              width: 30,
                              color: Theme.of(context).primaryColor,
                              iconStyle: IconStyle(
                                fontSize: 20,
                                color: Colors.white,
                                iconData: Icons.monetization_on,
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static IconData? getIcon(TicketStatusEnum status) {
    return {
      TicketStatusEnum.gracePeriod: Icons.access_alarm_outlined,
      TicketStatusEnum.notPaid: Icons.adjust,
      TicketStatusEnum.paid: Icons.monetization_on,
      TicketStatusEnum.pickedUp: Icons.add_road_sharp,
      TicketStatusEnum.scanned: Icons.camera_alt_rounded,
      TicketStatusEnum.exitedOnPaid: Icons.exit_to_app,
      TicketStatusEnum.free: Icons.wallet_giftcard,
      TicketStatusEnum.exitedOnGracePeriod: Icons.wallet_giftcard,
      TicketStatusEnum.exitedOnFree: Icons.wallet_giftcard,
    }[status];
  }
}
