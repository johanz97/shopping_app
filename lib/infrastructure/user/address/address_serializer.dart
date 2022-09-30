import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/user/address/address.dart';
import '../country/country_serializer.dart';

part 'address_serializer.freezed.dart';
part 'address_serializer.g.dart';

@freezed
class AddressSerializer with _$AddressSerializer {
  @JsonSerializable(explicitToJson: true)
  factory AddressSerializer({
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
    @JsonKey(name: "country") required CountrySerializer countrySerializer,
  }) = _AddressSerializer;

  const AddressSerializer._();

  factory AddressSerializer.fromJson(Map<String, dynamic> json) =>
      _$AddressSerializerFromJson(json);

  factory AddressSerializer.fromDomain(
    Address address,
  ) =>
      AddressSerializer(
        id: address.id,
        preferred: address.preferred,
        activated: address.activated,
        nickname: address.nickname,
        confirmationToken: address.confirmationToken,
        zipcode: address.zipcode,
        state: address.state,
        stateCode: address.stateCode,
        city: address.city,
        neighborhood: address.neighborhood,
        street: address.street,
        number: address.number,
        complement: address.complement,
        countrySerializer: CountrySerializer.fromDomain(address.country),
      );

  Address toDomain() => Address(
        id: id,
        preferred: preferred,
        activated: activated,
        nickname: nickname,
        confirmationToken: confirmationToken,
        zipcode: zipcode,
        state: state,
        stateCode: stateCode,
        city: city,
        neighborhood: neighborhood,
        street: street,
        number: number,
        complement: complement,
        country: countrySerializer.toDomain(),
      );

  Map<String, dynamic> toMapParkingLot() {
    return {
      'zipcode': zipcode,
      'state': stateCode,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'street_number': number,
      'complementary': complement,
    };
  }
}
