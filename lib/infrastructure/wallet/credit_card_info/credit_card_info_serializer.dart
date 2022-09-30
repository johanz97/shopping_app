import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../user/address/address_serializer.dart';

part 'credit_card_info_serializer.freezed.dart';
part 'credit_card_info_serializer.g.dart';

@freezed
class CreditCardInfoSerializer with _$CreditCardInfoSerializer {
  @JsonSerializable(explicitToJson: true)
  factory CreditCardInfoSerializer({
    int? id,
    @JsonKey(name: 'address') required AddressSerializer addressSerializer,
    required String cardNumber,
    required String cardCVVNumber,
    required String holderName,
    required String cardMonth,
    required String cardYear,
    required String cpfCnpj,
    required String cardType,
  }) = _CreditCardInfoSerializer;

  const CreditCardInfoSerializer._();

  factory CreditCardInfoSerializer.fromJson(Map<String, dynamic> json) =>
      _$CreditCardInfoSerializerFromJson(json);

  factory CreditCardInfoSerializer.fromDomain(
    CreditCardInfo creditCardInfo,
  ) =>
      CreditCardInfoSerializer(
        id: creditCardInfo.id,
        addressSerializer: AddressSerializer.fromDomain(creditCardInfo.address),
        cardNumber: creditCardInfo.cardNumber,
        cardCVVNumber: creditCardInfo.cardCVVNumber,
        holderName: creditCardInfo.holderName,
        cardMonth: creditCardInfo.cardMonth,
        cardYear: creditCardInfo.cardYear,
        cpfCnpj: creditCardInfo.cpfCnpj,
        cardType: creditCardInfo.cardType.value.toString(),
      );

  CreditCardInfo toDomain() => CreditCardInfo(
        id: id,
        address: addressSerializer.toDomain(),
        cardNumber: cardNumber,
        cardCVVNumber: cardCVVNumber,
        holderName: holderName,
        cardMonth: cardMonth,
        cardYear: cardYear,
        cpfCnpj: cpfCnpj,
        cardType: CreditCardTypeEx.toEnum[cardType]!,
      );
}
