import 'package:freezed_annotation/freezed_annotation.dart';

import 'enviroment/env.dart';
import 'location/location.dart';
import 'marketing/marketing.dart';

part 'enviroments.freezed.dart';

@freezed
class Enviroments with _$Enviroments {
  const factory Enviroments({
    required int marketplaceId,
    required String placeId,
    required String name,
    required String codeName,
    required Location location,
    required List<String> developers,
    required Marketing marketing,
    required String defaultPrdEnv,
    required String defaultDevEnv,
    required Map<String, Env> env,
  }) = _Enviroments;
}
