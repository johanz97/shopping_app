import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/parking_item/parking_item.dart';

part 'parking_item_serializer.freezed.dart';
part 'parking_item_serializer.g.dart';

@freezed
class ParkingItemSerializer with _$ParkingItemSerializer {
  @JsonSerializable(createToJson: true)
  factory ParkingItemSerializer({
    required String id,
    @JsonKey(name: 'unit_price') required String unitPrice,
  }) = _ParkingItemSerializer;

  const ParkingItemSerializer._();

  factory ParkingItemSerializer.fromJson(Map<String, dynamic> json) =>
      _$ParkingItemSerializerFromJson(json);

  factory ParkingItemSerializer.fromDomain(
    ParkingItem parkingItem,
  ) =>
      ParkingItemSerializer(
        id: parkingItem.id,
        unitPrice: parkingItem.unitPrice,
      );

  ParkingItem toDomain() => ParkingItem(
        id: id,
        unitPrice: unitPrice,
      );
}
