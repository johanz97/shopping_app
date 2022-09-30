import 'package:freezed_annotation/freezed_annotation.dart';

import '../../parking_lot/payment_authorization_response/payment_authorization_response.dart';

import '../ticket_sale/ticket_sale.dart';

part 'ticket_status.freezed.dart';

@freezed
class TicketStatus with _$TicketStatus {
  const factory TicketStatus({
    required String ticketId,
    @Default(0.0) double? value,
    @Default(0.0) double? paidValue,
    @Default(0.0) double? valueNoDiscount,
    @Default(0.0) double? discountValue,
    @Default(0) int? numberOfPayments,
    required DateTime entraceDate,
    DateTime? exitAllowedDate,
    required DateTime requestDate,
    TicketSale? ticketSale,
    bool? isOnSale,
    double? fee,
    required TicketStatusEnum status,
    PaymentAuthorizationResponse? paymentAuthorizationResponse,
    required String parkingLotName,
    required DateTime gracePeriodMaxTime,
  }) = _TicketStatus;

  const TicketStatus._();

  /// The allowed date the user can exit depending on the free or payment restrictions.
  DateTime? get getExitAllowedDateTime =>
      paymentAuthorizationResponse?.exitDateTime ?? exitAllowedDate;

  /// If the ticket is on the grace period (20min). Show the UI as (FREE)
  bool get isInGracePeriod => status == TicketStatusEnum.gracePeriod;

  /// If the ticket is paid
  bool get isPaid =>
      status == TicketStatusEnum.paid ||
      (paymentAuthorizationResponse?.paidTicket ?? false);

  /// If the ticket is free during the weekends, holidays, etc
  bool get isFree => status == TicketStatusEnum.free;

  /// If the ticket needs to be paid
  bool get needsPayment => status == TicketStatusEnum.notPaid;

  /// If the ticket has left the parking lot
  bool get hasExited => [
        TicketStatusEnum.exitedOnFree,
        TicketStatusEnum.exitedOnGracePeriod,
        TicketStatusEnum.exitedOnPaid
      ].contains(status);

  double get valueToBePaid =>
      (value! - paidValue!) + ((numberOfPayments! + 1) * fee!) - discountValue!;
}

enum TicketStatusEnum {
  free,
  pickedUp,
  scanned,
  gracePeriod,
  notPaid,
  paid,
  exitedOnPaid,
  exitedOnGracePeriod,
  exitedOnFree,
}

extension TicketStatusEx on TicketStatusEnum {
  static const valueMap = {
    TicketStatusEnum.pickedUp: "Pego na cancela",
    TicketStatusEnum.scanned: "Scaneado",
    TicketStatusEnum.free: 'Grátis',
    TicketStatusEnum.gracePeriod: 'Período gratuito',
    TicketStatusEnum.notPaid: 'Ticket não pago',
    TicketStatusEnum.paid: 'Ticket pago',
    TicketStatusEnum.exitedOnFree: 'Saiu em grátis',
    TicketStatusEnum.exitedOnGracePeriod: 'Saiu em periodo gratuito',
    TicketStatusEnum.exitedOnPaid: 'Saiu após pagamento',
  };

  static const toEnum = {
    'FREE': TicketStatusEnum.free,
    'PICKED_UP': TicketStatusEnum.pickedUp,
    'SCANNED': TicketStatusEnum.scanned,
    'GRACE_PERIOD': TicketStatusEnum.gracePeriod,
    'NOT_PAID': TicketStatusEnum.notPaid,
    'PAID': TicketStatusEnum.paid,
    'EXITED_ON_PAID': TicketStatusEnum.exitedOnPaid,
    'EXITED_ON_GRACE_PERIOD': TicketStatusEnum.exitedOnGracePeriod,
    'EXITED_ON_FREE': TicketStatusEnum.exitedOnFree,
  };

  static const fromEnumToStr = {
    TicketStatusEnum.pickedUp: "Pego na cancela",
    TicketStatusEnum.scanned: "Scaneado",
    TicketStatusEnum.free: 'Grátis',
    TicketStatusEnum.gracePeriod: 'Período gratuito',
    TicketStatusEnum.notPaid: 'Ticket não pago',
    TicketStatusEnum.paid: 'Ticket pago',
    TicketStatusEnum.exitedOnFree: 'Saiu em grátis',
    TicketStatusEnum.exitedOnGracePeriod: 'Saiu em periodo gratuito',
    TicketStatusEnum.exitedOnPaid: 'Saiu após pagamento',
  };

  String? get value => valueMap[this];

  String? get toStr => fromEnumToStr[this];
}
