import 'package:freezed_annotation/freezed_annotation.dart';

part 'parking_lot_sales.freezed.dart';

@freezed
class ParkingLotSales with _$ParkingLotSales {
  const factory ParkingLotSales({
    required List<String> daysOfWeek,
    required int systemId,
    required int discountValue,
  }) = _ParkingLotSales;
}
