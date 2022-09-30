import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../../../aplication/ticket/tickets_archive/tickets_archive_bloc.dart';
import '../../../../injection.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/ticket_widget.dart';
import '../home_ticket_page.dart';
import 'widgets/body_ticket_archive.dart';
import 'widgets/bottom_ticket_archive.dart';

class TicketsArchivePage extends StatefulWidget {
  const TicketsArchivePage({Key? key}) : super(key: key);

  @override
  State<TicketsArchivePage> createState() => _TicketsArchivePageState();
}

class _TicketsArchivePageState extends State<TicketsArchivePage> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        leading: BackButtonCustom(
          onTap: () => context.router.pop(),
        ),
        centerTitle: false,
        title: Text(
          "tickets_archive_page.title".tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<TicketsArchiveBloc>()
          ..add(
            const TicketsArchiveEvent.getUserTickets(),
          ),
        child: BlocBuilder<TicketsArchiveBloc, TicketsArchiveState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => Container(),
              loadInProgress: () => const LoadingState(),
              loadFailure: (failure) => ErrorState(
                failure: failure,
              ),
              userTickets: (tickets) => Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    right: 50.w,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 4.0),
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            color: Color.fromRGBO(196, 196, 196, .76),
                          )
                        ],
                      ),
                      height: 50.h,
                      width: 0.2.sw,
                      child: Center(
                        child: Text(
                          "$index/${tickets.length}".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  StackedCardCarousel(
                    initialOffset: 100.h,
                    spaceBetweenItems: 450.h,
                    onPageChanged: (page) {
                      setState(() {
                        index = page + 1;
                      });
                    },
                    type: StackedCardCarouselType.fadeOutStack,
                    items: List.generate(
                      tickets.length,
                      (indexT) => TicketWidget(
                        isFirst: index == (indexT + 1),
                        details: tickets[indexT],
                        body: BodyTicketArchive(
                          ticket: tickets[indexT],
                        ),
                        botom: BottomTicketArchive(
                          ticketNumber: tickets[indexT].ticketNumber.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
