import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/parking_lot_sales/parking_lot_sales.dart';

part 'parking_lot_sales_serializer.freezed.dart';
part 'parking_lot_sales_serializer.g.dart';

@freezed
class ParkingLotSalesSerializer with _$ParkingLotSalesSerializer {
  @JsonSerializable(createToJson: true)
  factory ParkingLotSalesSerializer({
    @JsonKey(name: 'diasSemana') required List<String> daysOfWeek,
    required int systemId,
    @JsonKey(name: 'valorDesconto') required int discountValue,
  }) = _ParkingLotSalesSerializer;

  const ParkingLotSalesSerializer._();

  factory ParkingLotSalesSerializer.fromJson(Map<String, dynamic> json) =>
      _$ParkingLotSalesSerializerFromJson(json);

  ParkingLotSales toDomain() => ParkingLotSales(
        daysOfWeek: daysOfWeek,
        systemId: systemId,
        discountValue: discountValue,
      );
}
