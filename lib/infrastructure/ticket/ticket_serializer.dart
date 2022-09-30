import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/ticket/ticket.dart';
import '../parking_lot/payment/payment_serializer.dart';
import 'ticket_state/ticket_state_serializer.dart';

part 'ticket_serializer.freezed.dart';
part 'ticket_serializer.g.dart';

@freezed
class TicketSerializer with _$TicketSerializer {
  @JsonSerializable(explicitToJson: true)
  factory TicketSerializer({
    required int ticketNumber,
    required int userId,
    required int storeId,
    required int createdAt,
    @JsonKey(name: 'payments') List<PaymentSerializer>? paymentsSerializer,
    @JsonKey(name: 'states') List<TicketStateSerializer>? statesSerializer,
  }) = _TicketSerializer;

  const TicketSerializer._();

  factory TicketSerializer.fromJson(Map<String, dynamic> json) =>
      _$TicketSerializerFromJson(json);

  Ticket toDomain() => Ticket(
        ticketNumber: ticketNumber,
        userId: userId,
        storeId: storeId,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        payments: paymentsSerializer != null
            ? paymentsSerializer!.map((e) => e.toDomain()).toList()
            : null,
        states: statesSerializer != null
            ? statesSerializer!.map((e) => e.toDomain()).toList()
            : null,
      );
}
