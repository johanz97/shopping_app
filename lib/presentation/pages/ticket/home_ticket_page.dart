import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../aplication/ticket/ticket_watcher_bloc/ticket_watcher_bloc.dart';
import '../../../aplication/wallet/select_card/select_card_bloc.dart';
import '../../../domain/parking_lot/payment_request_failure.dart';
import '../../../domain/ticket/ticket.dart';
import '../../../domain/ticket/ticket_failure.dart';
import '../../../domain/ticket/ticket_status/ticket_status.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../injection.dart';
import '../../core/pages/info_pages/unknown_page.dart';
import '../../core/pages/loading/loading_state_page.dart';
import '../../core/widgets/custom_buttom.dart';
import '../../core/widgets/custom_text_button.dart';
import '../../core/widgets/scafold_core.dart';
import '../../core/widgets/ticket_widget.dart';
import '../../routes/router.gr.dart';
import 'widgets/body_ticket.dart';
import 'widgets/bottom_ticket.dart';
import 'widgets/credit_cards_list_modal.dart';
import 'widgets/ticket_input_modal.dart';
import 'widgets/tutorial_steper.dart';

class HomeTicketPage extends StatelessWidget {
  final TicketStatus? ticketStatus;
  const HomeTicketPage({
    Key? key,
    this.ticketStatus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TicketWatcherBloc>()
        ..add(
          const TicketWatcherEvent.watchStarted(),
        ),
      child: ScaffoldCore(
        body: BlocConsumer<TicketWatcherBloc, TicketWatcherState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.maybeMap(
              initial: (_) => const BarScannerWidget(),
              notPaidTicket: (ticket) => TicketNotPaidStatusWidget(
                ticket: ticket.ticket,
                details: ticket.details,
              ),
              paidTicket: (ticket) => TicketPaidStatusWidget(
                ticket: ticket.ticket,
                details: ticket.details,
              ),
              loadInProgress: (_) => const LoadingState(),
              loadFailure: (failure) => ErrorState(
                failure: failure.failure,
              ),
              paymentInProgress: (_) => const LoadingStatePage(
                animation: "assets/animations/credit_card.json",
              ),
              paymentFailure: (failure) => PaymentFailureState(
                failure: failure.failure,
              ),
              ticketNotFound: (_) => UnknownPage(
                reload: () => context.read<TicketWatcherBloc>().add(
                      const TicketWatcherEvent.archiveTicket(),
                    ),
              ),
              orElse: () => Container(),
            );
          },
        ),
      ),
    );
  }
}

class BarScannerWidget extends StatefulWidget {
  const BarScannerWidget({Key? key}) : super(key: key);
  @override
  State<BarScannerWidget> createState() => _BarScannerWidgetState();
}

class _BarScannerWidgetState extends State<BarScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const TutorialSteper(),
        Positioned(
          bottom: 10,
          child: Column(
            children: [
              CustomButtom(
                onTap: () async {
                  final ticketId = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666',
                    'Cancel',
                    true,
                    ScanMode.BARCODE,
                  );
                  if (!mounted) return;
                  if (ticketId != '-1') {
                    context.read<TicketWatcherBloc>().add(
                          TicketWatcherEvent.watchStarted(
                            ticketId: ticketId,
                          ),
                        );
                  }
                },
                icon: Icons.qr_code,
                title: 'ticket_scanner_tutorial.action_1'.tr(),
                width: 1.sw,
                isActive: true,
              ),
              SizedBox(height: 20.h),
              Visibility(
                visible: false,
                child: CustomTextButton(
                  onPressed: () async {
                    final ticketId = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(),
                      builder: (context) {
                        return const TicketInputModal();
                      },
                    );
                    if (!mounted) return;
                    if (ticketId != null) {
                      context.read<TicketWatcherBloc>().add(
                            TicketWatcherEvent.watchStarted(
                              ticketId: ticketId as String,
                            ),
                          );
                    }
                  },
                  content: 'ticket_scanner_tutorial.action_2'.tr(),
                  width: 330,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TicketPaidStatusWidget extends StatelessWidget {
  final TicketStatus ticket;
  final Ticket? details;
  const TicketPaidStatusWidget({
    Key? key,
    required this.ticket,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
        ),
        Column(
          children: [
            Visibility(
              visible: ticket.isPaid,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 70.w,
                ),
                child: Text(
                  'TicketPaidStatusWidget.subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            Visibility(
              visible: ticket.hasExited,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 60.w,
                ),
                child: Text(
                  'TicketPaidStatusWidget.subtitle_2'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50.h,
        ),
        TicketWidget(
          details: details,
          body: BodyTicket(
            ticket: ticket,
          ),
          botom: BottomTicket(
            ticket: ticket,
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        CustomTextButton(
          content: 'TicketPaidStatusWidget.action_1'.tr(),
          onPressed: () => context.read<TicketWatcherBloc>().add(
                const TicketWatcherEvent.archiveTicket(),
              ),
        ),
      ],
    );
  }
}

class TicketNotPaidStatusWidget extends StatelessWidget {
  final TicketStatus ticket;
  final Ticket? details;
  const TicketNotPaidStatusWidget({
    Key? key,
    required this.ticket,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SelectCardBloc>()
        ..add(
          const SelectCardEvent.getCreditCards(),
        ),
      child: BlocBuilder<SelectCardBloc, SelectCardState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: ticket.isFree || ticket.isInGracePeriod ? 140.h : 70.h,
              ),
              Column(
                children: [
                  Visibility(
                    visible: ticket.isInGracePeriod,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70.w),
                      child: Text(
                        'TicketNotPaidStatusWidget.subTitle'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: ticket.isFree,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70.w),
                      child: Text(
                        'TicketNotPaidStatusWidget.subtitle_3'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              TicketWidget(
                details: details,
                body: BodyTicket(
                  ticket: ticket,
                ),
                botom: BottomTicket(
                  ticket: ticket,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Visibility(
                visible: ticket.needsPayment,
                child: Container(
                  margin: EdgeInsets.only(top: 80.h),
                  child: CustomButtom(
                    isActive: true,
                    width: 1.3.sw,
                    onTap: () => state.creditCards.isNotEmpty
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (contextM) => BlocProvider.value(
                              value: BlocProvider.of<SelectCardBloc>(context),
                              child: CreditCardsListModal(
                                onAccept: (CreditCardInfo selectedCreditCard) {
                                  context.router.pop();
                                  context.read<TicketWatcherBloc>().add(
                                        TicketWatcherEvent.payTicket(
                                          ticket,
                                          selectedCreditCard,
                                          details,
                                        ),
                                      );
                                },
                                onCancel: () => context.router.pop(),
                              ),
                            ),
                          )
                        : context.router.pushAndPopUntil(
                            const UserWelcomeFormRoute(),
                            predicate: (e) => false,
                          ),
                    title: 'TicketNotPaidStatusWidget.action'.tr(),
                  ),
                ),
              ),
              CustomTextButton(
                content: 'TicketPaidStatusWidget.action_1'.tr(),
                onPressed: () => context.read<TicketWatcherBloc>().add(
                      const TicketWatcherEvent.archiveTicket(),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final TicketFailure failure;
  const ErrorState({Key? key, required this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250.h,
            ),
            Lottie.asset(
              failure.map(
                notInternet: (_) => 'assets/animations/error.json',
                unexpected: (_) => 'assets/animations/error.json',
                serverIsDown: (_) => 'assets/animations/error.json',
                ticketNotFound: (_) => 'assets/animations/not-found.json',
                timeLimitExceeded: (_) => 'assets/animations/error.json',
                ticketEmpty: (_) => 'assets/animations/not-found.json',
                ticketIncorrect: (_) => 'assets/animations/error.json',
              ),
              height: 320.h,
            ),
            SizedBox(
              height: 40.h,
            ),
            failure.maybeMap(
              orElse: () => Container(),
              unexpected: (_) => Text(
                'ErrorState.error_1'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              ticketNotFound: (e) => Text(
                'ErrorState.error_2'.tr(args: [e.ticketNumber]),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              serverIsDown: (_) => Text(
                'ErrorState.error_3'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              ticketEmpty: (_) => Text(
                'ErrorState.error_5'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              ticketIncorrect: (_) => Text(
                'ErrorState.error_6'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'ErrorState.action'.tr(),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150.h,
            ),
            SizedBox(
              width: 0.6.sw,
              height: 0.06.sh,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Volver a intentar"),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              child: const Text("Cancelar"),
              onPressed: () {
                context
                    .read<TicketWatcherBloc>()
                    .add(const TicketWatcherEvent.archiveTicket());
              },
            ),
          ],
        )
      ],
    );
  }
}

class PaymentFailureState extends StatelessWidget {
  final PaymentRequestFailure failure;
  const PaymentFailureState({Key? key, required this.failure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250.h,
            ),
            Lottie.asset(
              failure.map(
                notInternet: (_) => 'assets/animations/error.json',
                unexpected: (_) => 'assets/animations/error.json',
                serverIsDown: (_) => 'assets/animations/error.json',
                timeLimitExceeded: (_) => 'assets/animations/error.json',
              ),
              height: 320.h,
            ),
            SizedBox(
              height: 40.h,
            ),
            failure.maybeMap(
              orElse: () => Container(),
              unexpected: (_) => Text(
                'ErrorState.error_1'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              serverIsDown: (_) => Text(
                'ErrorState.error_3'.tr(),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'ErrorState.action'.tr(),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150.h,
            ),
            SizedBox(
              width: 0.6.sw,
              height: 0.06.sh,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  context
                      .read<TicketWatcherBloc>()
                      .add(const TicketWatcherEvent.watchStarted());
                },
                child: const Text("Volver a intentar"),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class LoadingState extends StatefulWidget {
  const LoadingState({
    Key? key,
  }) : super(key: key);

  @override
  _LoadingStateState createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
      value: 640,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _animationController,
        child: SizedBox(
          height: 0.84.sh,
          child: Image.asset(
            'assets/img/loading.png',
            height: 200.sp,
            width: 200.sp,
          ),
        ),
      ),
    );
  }
}
