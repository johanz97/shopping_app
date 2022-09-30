import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/enviroments.dart';
import '../enviroment/env_serializer.dart';
import '../location/location_serializer.dart';
import '../marketing/marketing_serializer.dart';

part 'enviroments_serializer.freezed.dart';
part 'enviroments_serializer.g.dart';

@freezed
class EnviromentsSerializer with _$EnviromentsSerializer {
  @JsonSerializable(explicitToJson: true)
  factory EnviromentsSerializer({
    required int marketplaceId,
    required String placeId,
    required String name,
    required String codeName,
    @JsonKey(name: "location") required LocationSerializer locationSerializer,
    required List<String> developers,
    @JsonKey(name: "marketing")
        required MarketingSerializer marketingSerializer,
    required String defaultPrdEnv,
    required String defaultDevEnv,
    @JsonKey(name: "env") required Map<String, EnvSerializer> envSerializer,
  }) = _EnviromentsSerializer;

  const EnviromentsSerializer._();

  factory EnviromentsSerializer.fromJson(Map<String, dynamic> json) =>
      _$EnviromentsSerializerFromJson(json);

  Enviroments toDomain() => Enviroments(
        marketplaceId: marketplaceId,
        placeId: placeId,
        name: name,
        codeName: codeName,
        location: locationSerializer.toDomain(),
        developers: developers,
        marketing: marketingSerializer.toDomain(),
        defaultPrdEnv: defaultPrdEnv,
        defaultDevEnv: defaultDevEnv,
        env: envSerializer.map(
          (key, envSerializer) => MapEntry(
            key,
            envSerializer.toDomain(),
          ),
        ),
      );
}
