import 'package:freezed_annotation/freezed_annotation.dart';

part 'search.freezed.dart';

@freezed
class Search with _$Search {
  const factory Search({
    required int radius,
    required List<String> tieBreakKeywords,
  }) = _Search;
}
