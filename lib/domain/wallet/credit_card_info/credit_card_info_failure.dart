import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_info_failure.freezed.dart';

//Definition of existing errors in the credit_card_info object
@freezed
class CreditCardInfoFailure with _$CreditCardInfoFailure {
  factory CreditCardInfoFailure.creditCardAlreadyExists() =
      CreditCardAlreadyExists;
  factory CreditCardInfoFailure.notInternet() = NotInternet;
  factory CreditCardInfoFailure.serverIsDown() = ServerIsDown;
  factory CreditCardInfoFailure.timeLimitExceeded() = TimeLimitExceeded;
  factory CreditCardInfoFailure.unexpected() = Unexpected;
}
