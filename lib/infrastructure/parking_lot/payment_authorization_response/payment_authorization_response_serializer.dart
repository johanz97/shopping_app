import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/payment_authorization_response/payment_authorization_response.dart';

part 'payment_authorization_response_serializer.freezed.dart';
part 'payment_authorization_response_serializer.g.dart';

@freezed
class PaymentAuthorizationResponseSerializer
    with _$PaymentAuthorizationResponseSerializer {
  @JsonSerializable(createToJson: true)
  factory PaymentAuthorizationResponseSerializer({
    @JsonKey(name: 'dataHoraSaida') required int exitDateTime,
    @JsonKey(name: 'dataPagamento') required int paymentDateTime,
    @JsonKey(name: 'ticketPago') required bool paidTicket,
    @JsonKey(name: 'mensagem') required String message,
    @JsonKey(name: 'numeroTicket') required String ticketNumber,
  }) = _PaymentAuthorizationResponseSerializer;

  const PaymentAuthorizationResponseSerializer._();

  factory PaymentAuthorizationResponseSerializer.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PaymentAuthorizationResponseSerializerFromJson(json);

  factory PaymentAuthorizationResponseSerializer.fromDomain(
    PaymentAuthorizationResponse paymentAuthorizationResponse,
  ) =>
      PaymentAuthorizationResponseSerializer(
        exitDateTime:
            paymentAuthorizationResponse.exitDateTime.millisecondsSinceEpoch,
        paymentDateTime:
            paymentAuthorizationResponse.paymentDateTime.millisecondsSinceEpoch,
        paidTicket: paymentAuthorizationResponse.paidTicket,
        message: paymentAuthorizationResponse.message,
        ticketNumber: paymentAuthorizationResponse.ticketNumber,
      );

  PaymentAuthorizationResponse toDomain() => PaymentAuthorizationResponse(
        exitDateTime: DateTime.fromMillisecondsSinceEpoch(exitDateTime),
        paymentDateTime: DateTime.fromMillisecondsSinceEpoch(paymentDateTime),
        paidTicket: paidTicket,
        message: message,
        ticketNumber: ticketNumber,
      );
}
