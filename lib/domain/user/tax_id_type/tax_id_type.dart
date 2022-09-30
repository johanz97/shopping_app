import 'package:freezed_annotation/freezed_annotation.dart';

import '../country/country.dart';

part 'tax_id_type.freezed.dart';

@freezed
class TaxIdType with _$TaxIdType {
  const factory TaxIdType({
    required String id,
    required String description,
    required Country country,
  }) = _TaxIdType;
}
