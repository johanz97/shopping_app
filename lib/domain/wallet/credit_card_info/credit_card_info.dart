import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/config_reader.dart';

import '../../user/address/address.dart';

part 'credit_card_info.freezed.dart';

@freezed
class CreditCardInfo with _$CreditCardInfo {
  const factory CreditCardInfo({
    int? id,
    required Address address,
    required String cardNumber,
    required String cardCVVNumber,
    required String holderName,
    required String cardMonth,
    required String cardYear,
    required String cpfCnpj,
    required CreditCardType cardType,
  }) = _CreditCardInfo;

  factory CreditCardInfo.test() {
    final testCreditcard = ConfigReader.getTestCreditCard();
    return CreditCardInfo(
      id: 0,
      address: Address.empty(),
      cardNumber: testCreditcard['number'] as String,
      cardCVVNumber: testCreditcard['cvv'] as String,
      holderName: testCreditcard['name'] as String,
      cardMonth: testCreditcard['expMonth'] as String,
      cardYear: testCreditcard['expYear'] as String,
      cpfCnpj: testCreditcard['cpf'] as String,
      cardType: CreditCardType.indivudual,
    );
  }
}

enum CreditCardType { indivudual, corporativo }

extension CreditCardTypeEx on CreditCardType {
  static const _valueMap = {
    CreditCardType.corporativo: 'CORPORATION',
    CreditCardType.indivudual: 'INDIVIDUAL',
  };

  static const toEnum = {
    'CORPORATION': CreditCardType.corporativo,
    'INDIVIDUAL': CreditCardType.indivudual,
  };

  String? get value => _valueMap[this];
}
