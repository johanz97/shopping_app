import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

@freezed
class Payment with _$Payment {
  factory Payment({
    required int id,
    required int amount,
    required DateTime date,
    required int serviceFee,
  }) = _Payment;
  Payment._();

  double get total => (amount + serviceFee) / 100;
}
