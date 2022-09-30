import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/ticket/ticket_sale/ticket_sale.dart';

part 'ticket_sale_serializer.freezed.dart';
part 'ticket_sale_serializer.g.dart';

@freezed
class TicketSaleSerializer with _$TicketSaleSerializer {
  @JsonSerializable(createToJson: true)
  factory TicketSaleSerializer({
    @JsonKey(name: 'sale_id') required int saleId,
    required double amount,
  }) = _TicketSaleSerializer;

  const TicketSaleSerializer._();

  factory TicketSaleSerializer.fromJson(Map<String, dynamic> json) =>
      _$TicketSaleSerializerFromJson(json);

  factory TicketSaleSerializer.fromDomain(TicketSale ticketSale) =>
      TicketSaleSerializer(
        saleId: ticketSale.saleId,
        amount: ticketSale.amount,
      );

  TicketSale toDomain() => TicketSale(
        saleId: saleId,
        amount: amount,
      );
}
