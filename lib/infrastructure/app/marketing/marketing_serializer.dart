import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/marketing/marketing.dart';

part 'marketing_serializer.freezed.dart';
part 'marketing_serializer.g.dart';

@freezed
class MarketingSerializer with _$MarketingSerializer {
  @JsonSerializable(createToJson: true)
  factory MarketingSerializer({
    required String whatsapp,
    required String facebook,
    required String instagram,
    required String twitter,
  }) = _MarketingSerializer;

  const MarketingSerializer._();

  factory MarketingSerializer.fromJson(Map<String, dynamic> json) =>
      _$MarketingSerializerFromJson(json);

  Marketing toDomain() => Marketing(
        whatsapp: whatsapp,
        facebook: facebook,
        instagram: instagram,
        twitter: twitter,
      );
}
