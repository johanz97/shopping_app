import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
class Country with _$Country {
  const factory Country({
    required int id,
    required String name,
    required int code,
  }) = _Country;

  factory Country.empty() => const Country(
        id: 0,
        name: "Unknown",
        code: 0,
      );
}
