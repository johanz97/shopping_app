import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/payment/payment.dart';

part 'payment_serializer.freezed.dart';
part 'payment_serializer.g.dart';

@freezed
class PaymentSerializer with _$PaymentSerializer {
  @JsonSerializable(createToJson: true)
  factory PaymentSerializer({
    required int id,
    required int amount,
    required int date,
    @JsonKey(name: 'service_fee') required int serviceFee,
  }) = _PaymentSerializer;

  const PaymentSerializer._();

  factory PaymentSerializer.fromJson(Map<String, dynamic> json) =>
      _$PaymentSerializerFromJson(json);

  Payment toDomain() => Payment(
        id: id,
        amount: amount,
        date: DateTime.fromMillisecondsSinceEpoch(date),
        serviceFee: serviceFee,
      );
}
