import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/ticket/ticket.dart';

class BodyTicketArchive extends StatelessWidget {
  final Ticket ticket;
  const BodyTicketArchive({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat('##0.00#');
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.green,
            child: Container(
              height: 50.h,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "tickets_archive_page.ticket_header".tr(),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 50.w,
            ),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Text(
                      'tickets_archive_page.table_values.item_1'.tr(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(ticket.ticketNumber.toString()),
                      ],
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'tickets_archive_page.table_values.item_3'.tr(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(DateFormat.yMMMMd().format(ticket.createdAt)),
                      ],
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'tickets_archive_page.table_values.item_2'.tr(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'R\$ ',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(f.format(ticket.totalPayment)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
