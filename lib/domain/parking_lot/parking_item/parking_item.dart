import 'package:freezed_annotation/freezed_annotation.dart';

part 'parking_item.freezed.dart';

@freezed
class ParkingItem with _$ParkingItem {
  const factory ParkingItem({
    required String id,
    required String unitPrice,
  }) = _ParkingItem;
}
