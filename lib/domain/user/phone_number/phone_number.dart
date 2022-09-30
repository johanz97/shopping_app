import 'package:freezed_annotation/freezed_annotation.dart';

import '../country/country.dart';

part 'phone_number.freezed.dart';

@freezed
class PhoneNumber with _$PhoneNumber {
  const factory PhoneNumber({
    required int id,
    required bool preferred,
    required bool activated,
    String? nickname,
    required String confirmationToken,
    required Country country,
    required int areaCode,
    required int number,
    String? provider,
  }) = _PhoneNumber;

  factory PhoneNumber.empty() => PhoneNumber(
        activated: true,
        id: 0,
        areaCode: 00,
        confirmationToken: '',
        country: Country.empty(),
        number: 000000000,
        preferred: false,
      );
}
