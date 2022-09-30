import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../domain/ticket/ticket_status/ticket_status.dart';

class TableValues extends StatelessWidget {
  final TicketStatus ticket;
  const TableValues({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat('##0.00#');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Table(
        children: [
          if (ticket.paidValue != 0)
            TableRow(
              children: [
                Text(
                  'TableValues.add_value'.tr(),
                  style: Theme.of(context).textTheme.caption,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(f.format(ticket.valueToBePaid)),
                  ],
                )
              ],
            ),
          if (ticket.paidValue != 0)
            TableRow(
              children: [
                Text(
                  'TableValues.valor_pago'.tr(),
                  style: Theme.of(context).textTheme.caption,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      '-${f.format(ticket.value)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          if (ticket.needsPayment && ticket.paidValue == 0)
            TableRow(
              children: [
                Row(
                  children: [
                    Text(
                      'TableValues.value'.tr(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: ticket.numberOfPayments! > 0,
                      child: Text(
                        'X${ticket.numberOfPayments}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      f.format(ticket.value),
                    ),
                  ],
                )
              ],
            ),
          if (ticket.needsPayment)
            TableRow(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'TableValues.rate'.tr(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(f.format(ticket.fee ?? 80)),
                  ],
                )
              ],
            ),
          if (ticket.needsPayment)
            TableRow(
              children: [
                SvgPicture.asset(
                  'assets/svg/line.svg',
                  height: 20,
                  width: 100,
                ),
                SvgPicture.asset(
                  'assets/svg/line.svg',
                  height: 20,
                  width: 100,
                ),
              ],
            ),
          TableRow(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TableValues.total'.tr(),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'R\$ ',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(f.format(ticket.valueToBePaid)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
