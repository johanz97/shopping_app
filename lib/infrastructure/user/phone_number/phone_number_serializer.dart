import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/phone_number/phone_number.dart';
import '../country/country_serializer.dart';

part 'phone_number_serializer.freezed.dart';
part 'phone_number_serializer.g.dart';

@freezed
class PhoneNumberSerializer with _$PhoneNumberSerializer {
  @JsonSerializable(explicitToJson: true)
  factory PhoneNumberSerializer({
    required int id,
    required bool preferred,
    required bool activated,
    String? nickname,
    required String confirmationToken,
    @JsonKey(name: "country") required CountrySerializer countrySerializer,
    required int areaCode,
    required int number,
    String? provider,
  }) = _PhoneNumberSerializer;

  const PhoneNumberSerializer._();

  factory PhoneNumberSerializer.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberSerializerFromJson(json);

  factory PhoneNumberSerializer.fromDomain(PhoneNumber phoneNumber) =>
      PhoneNumberSerializer(
        id: phoneNumber.id,
        preferred: phoneNumber.preferred,
        activated: phoneNumber.activated,
        nickname: phoneNumber.nickname,
        confirmationToken: phoneNumber.confirmationToken,
        countrySerializer: CountrySerializer.fromDomain(phoneNumber.country),
        areaCode: phoneNumber.areaCode,
        number: phoneNumber.number,
        provider: phoneNumber.provider,
      );

  PhoneNumber toDomain() => PhoneNumber(
        id: id,
        preferred: preferred,
        activated: activated,
        nickname: nickname,
        confirmationToken: confirmationToken,
        country: countrySerializer.toDomain(),
        areaCode: areaCode,
        number: number,
        provider: provider,
      );
}
