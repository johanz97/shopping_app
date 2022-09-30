import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/tax_id_type/tax_id_type.dart';
import '../country/country_serializer.dart';

part 'tax_id_type_serializer.freezed.dart';
part 'tax_id_type_serializer.g.dart';

@freezed
class TaxIdTypeSerializer with _$TaxIdTypeSerializer {
  @JsonSerializable(explicitToJson: true)
  factory TaxIdTypeSerializer({
    required String id,
    required String description,
    @JsonKey(name: "country") required CountrySerializer countrySerializer,
  }) = _TaxIdTypeSerializer;

  const TaxIdTypeSerializer._();

  factory TaxIdTypeSerializer.fromJson(Map<String, dynamic> json) =>
      _$TaxIdTypeSerializerFromJson(json);

  factory TaxIdTypeSerializer.fromDomain(TaxIdType taxIdType) =>
      TaxIdTypeSerializer(
        id: taxIdType.id,
        description: taxIdType.description,
        countrySerializer: CountrySerializer.fromDomain(taxIdType.country),
      );

  TaxIdType toDomain() => TaxIdType(
        id: id,
        description: description,
        country: countrySerializer.toDomain(),
      );
}
