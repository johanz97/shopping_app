import 'package:freezed_annotation/freezed_annotation.dart';

part 'gender.freezed.dart';

@freezed
class Gender with _$Gender {
  const factory Gender({
    required int id,
    required String description,
  }) = _Gender;

  factory Gender.empty() => const Gender(
        id: 3,
        description: "Não Definido",
      );
}
