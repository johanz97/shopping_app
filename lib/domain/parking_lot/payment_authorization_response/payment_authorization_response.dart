import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_authorization_response.freezed.dart';

@freezed
class PaymentAuthorizationResponse with _$PaymentAuthorizationResponse {
  const factory PaymentAuthorizationResponse({
    required DateTime exitDateTime,
    required DateTime paymentDateTime,
    required bool paidTicket,
    required String message,
    required String ticketNumber,
  }) = _PaymentAuthorizationResponse;
}
