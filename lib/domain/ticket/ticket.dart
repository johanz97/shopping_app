import 'package:freezed_annotation/freezed_annotation.dart';

import '../parking_lot/payment/payment.dart';
import 'ticket_state/ticket_state.dart';

part 'ticket.freezed.dart';

@freezed
class Ticket with _$Ticket {
  factory Ticket({
    required int ticketNumber,
    required int userId,
    required int storeId,
    required DateTime createdAt,
    List<Payment>? payments,
    List<TicketState>? states,
  }) = _Ticket;
  Ticket._();

  double get totalPayment => payments!.isNotEmpty
      ? payments!.reduce((value, element) {
          return Payment(
            id: value.id,
            date: value.date,
            amount: value.amount + element.amount,
            serviceFee: value.serviceFee + element.serviceFee,
          );
        }).total
      : 0;
}
