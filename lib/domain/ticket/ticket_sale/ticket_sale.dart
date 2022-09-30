import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_sale.freezed.dart';

@freezed
class TicketSale with _$TicketSale {
  const factory TicketSale({
    required int saleId,
    required double amount,
  }) = _TicketSale;
}
