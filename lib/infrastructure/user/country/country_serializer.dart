import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/country/country.dart';

part 'country_serializer.freezed.dart';
part 'country_serializer.g.dart';

@freezed
class CountrySerializer with _$CountrySerializer {
  @JsonSerializable(createToJson: true)
  factory CountrySerializer({
    required int id,
    required String name,
    required int code,
  }) = _CountrySerializer;

  const CountrySerializer._();

  factory CountrySerializer.fromJson(Map<String, dynamic> json) =>
      _$CountrySerializerFromJson(json);

  factory CountrySerializer.fromDomain(
    Country country,
  ) =>
      CountrySerializer(
        id: country.id,
        name: country.name,
        code: country.code,
      );

  Country toDomain() => Country(
        id: id,
        name: name,
        code: code,
      );
}
