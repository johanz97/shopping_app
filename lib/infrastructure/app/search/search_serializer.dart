import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/location/search/search.dart';

part 'search_serializer.freezed.dart';
part 'search_serializer.g.dart';

@freezed
class SearchSerializer with _$SearchSerializer {
  @JsonSerializable(createToJson: true)
  factory SearchSerializer({
    required int radius,
    required List<String> tieBreakKeywords,
  }) = _SearchSerializer;

  const SearchSerializer._();

  factory SearchSerializer.fromJson(Map<String, dynamic> json) =>
      _$SearchSerializerFromJson(json);

  Search toDomain() => Search(
        radius: radius,
        tieBreakKeywords: tieBreakKeywords,
      );
}
