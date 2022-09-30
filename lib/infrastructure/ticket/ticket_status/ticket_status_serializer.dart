import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/ticket/ticket_status/ticket_status.dart';
import '../../parking_lot/payment_authorization_response/payment_authorization_response_serializer.dart';
import '../ticket_sale/ticket_sale_serializer.dart';

part 'ticket_status_serializer.freezed.dart';
part 'ticket_status_serializer.g.dart';

@freezed
class TicketStatusSerializer with _$TicketStatusSerializer {
  @JsonSerializable(explicitToJson: true)
  factory TicketStatusSerializer({
    @JsonKey(name: 'numeroTicket') required String ticketId,
    @JsonKey(name: 'tarifa') @Default(0.0) double? value,
    @JsonKey(name: 'tarifaPaga') @Default(0.0) double? paidValue,
    @JsonKey(name: 'tarifaSemDesconto') @Default(0.0) double? valueNoDiscount,
    @JsonKey(name: 'valorDesconto') @Default(0.0) double? discountValue,
    @Default(0) int? numberOfPayments,
    @JsonKey(name: 'dataDeEntrada') required int entraceDate,
    @JsonKey(name: 'dataPermitidaSaida') int? exitAllowedDate,
    @JsonKey(name: 'dataConsulta') required int requestDate,
    @JsonKey(name: 'sale') TicketSaleSerializer? ticketSaleSerializer,
    bool? isOnSale,
    double? fee,
    @JsonKey(name: 'state') required String status,
    PaymentAuthorizationResponseSerializer?
        paymentAuthorizationResponseSerializer,
    @Default('Maceió Shopping') String? parkingLotName,
    required int gracePeriodMaxTime,
  }) = _TicketStatusSerializer;

  const TicketStatusSerializer._();

  factory TicketStatusSerializer.fromJson(Map<String, dynamic> json) =>
      _$TicketStatusSerializerFromJson(json);

  factory TicketStatusSerializer.fromDomain(TicketStatus ticketStatus) =>
      TicketStatusSerializer(
        ticketId: ticketStatus.ticketId,
        value: ticketStatus.value,
        paidValue: ticketStatus.paidValue,
        valueNoDiscount: ticketStatus.valueNoDiscount,
        discountValue: ticketStatus.discountValue,
        numberOfPayments: ticketStatus.numberOfPayments,
        entraceDate: ticketStatus.entraceDate.millisecondsSinceEpoch,
        exitAllowedDate: ticketStatus.exitAllowedDate != null
            ? ticketStatus.exitAllowedDate!.millisecondsSinceEpoch
            : null,
        requestDate: ticketStatus.requestDate.millisecondsSinceEpoch,
        ticketSaleSerializer: ticketStatus.ticketSale != null
            ? TicketSaleSerializer.fromDomain(ticketStatus.ticketSale!)
            : null,
        isOnSale: ticketStatus.isOnSale,
        fee: ticketStatus.fee,
        status: ticketStatus.status.value.toString(),
        paymentAuthorizationResponseSerializer:
            ticketStatus.paymentAuthorizationResponse != null
                ? PaymentAuthorizationResponseSerializer.fromDomain(
                    ticketStatus.paymentAuthorizationResponse!,
                  )
                : null,
        parkingLotName: ticketStatus.parkingLotName,
        gracePeriodMaxTime:
            ticketStatus.gracePeriodMaxTime.millisecondsSinceEpoch,
      );

  TicketStatus toDomain() => TicketStatus(
        ticketId: ticketId,
        value: value,
        paidValue: paidValue,
        valueNoDiscount: valueNoDiscount,
        discountValue: discountValue,
        numberOfPayments: numberOfPayments,
        entraceDate: DateTime.fromMillisecondsSinceEpoch(entraceDate).toUtc(),
        exitAllowedDate: exitAllowedDate != null
            ? DateTime.fromMillisecondsSinceEpoch(exitAllowedDate!).toUtc()
            : DateTime.fromMillisecondsSinceEpoch(entraceDate)
                .toUtc()
                .add(const Duration(hours: 2)),
        requestDate: DateTime.fromMillisecondsSinceEpoch(requestDate).toUtc(),
        ticketSale: ticketSaleSerializer != null
            ? ticketSaleSerializer!.toDomain()
            : null,
        isOnSale: isOnSale,
        fee: fee,
        status: TicketStatusEx.toEnum[status]!,
        paymentAuthorizationResponse:
            paymentAuthorizationResponseSerializer != null
                ? paymentAuthorizationResponseSerializer!.toDomain()
                : null,
        parkingLotName: parkingLotName ?? 'Maceió Shopping',
        gracePeriodMaxTime:
            DateTime.fromMillisecondsSinceEpoch(gracePeriodMaxTime).toUtc(),
      );
}
