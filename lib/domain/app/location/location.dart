import 'package:freezed_annotation/freezed_annotation.dart';

import 'center-viewPort/center_view_port.dart';
import 'search/search.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required Search search,
    required CenterViewport centerViewport,
    required CenterViewport logo,
  }) = _Location;
}
