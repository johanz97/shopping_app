import 'package:freezed_annotation/freezed_annotation.dart';

part 'center_view_port.freezed.dart';

@freezed
class CenterViewport with _$CenterViewport {
  const factory CenterViewport({
    required double lat,
    required double lon,
  }) = _CenterViewport;
}
