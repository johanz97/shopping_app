import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/gender/gender.dart';

part 'gender_serializer.freezed.dart';
part 'gender_serializer.g.dart';

@freezed
class GenderSerializer with _$GenderSerializer {
  @JsonSerializable(createToJson: true)
  factory GenderSerializer({
    required int id,
    required String description,
  }) = _GenderSerializer;

  const GenderSerializer._();

  factory GenderSerializer.fromJson(Map<String, dynamic> json) =>
      _$GenderSerializerFromJson(json);

  factory GenderSerializer.fromDomain(Gender gender) => GenderSerializer(
        id: gender.id,
        description: gender.description,
      );

  Gender toDomain() => Gender(
        id: id,
        description: description,
      );
}
