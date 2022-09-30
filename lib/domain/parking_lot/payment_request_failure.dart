import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_request_failure.freezed.dart';

//Definition of existing errors in the payment_request object
@freezed
class PaymentRequestFailure with _$PaymentRequestFailure {
  factory PaymentRequestFailure.notInternet() = NotInternet;
  factory PaymentRequestFailure.serverIsDown() = ServerIsDown;
  factory PaymentRequestFailure.timeLimitExceeded() = TimeLimitExceeded;
  factory PaymentRequestFailure.unexpected() = Unexpected;
}
