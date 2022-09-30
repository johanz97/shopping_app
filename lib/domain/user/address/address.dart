import 'package:freezed_annotation/freezed_annotation.dart';

import '../country/country.dart';

part 'address.freezed.dart';

@freezed
class Address with _$Address {
  const factory Address({
    @Default(0) int? id,
    required bool preferred,
    required bool activated,
    required String nickname,
    required String confirmationToken,
    required String zipcode,
    required String state,
    required String stateCode,
    required String city,
    required String neighborhood,
    required String street,
    required String number,
    required String complement,
    required Country country,
  }) = _Address;

  factory Address.empty() => Address(
        preferred: false,
        activated: false,
        nickname: "",
        confirmationToken: "",
        zipcode: "",
        state: "",
        stateCode: "",
        city: "",
        neighborhood: "",
        street: "",
        number: "",
        complement: "",
        country: Country.empty(),
      );
}
