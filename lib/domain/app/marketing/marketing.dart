import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketing.freezed.dart';

@freezed
class Marketing with _$Marketing {
  const factory Marketing({
    required String whatsapp,
    required String facebook,
    required String instagram,
    required String twitter,
  }) = _Marketing;
}
