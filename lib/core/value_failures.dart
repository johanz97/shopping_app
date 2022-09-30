import 'package:freezed_annotation/freezed_annotation.dart';
part 'value_failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.empty({
    required String failedValue,
  }) = Empty<T>;
  const factory ValueFailure.notIsOnlyString({
    required String failedValue,
  }) = NotIsOnlyString<T>;
  const factory ValueFailure.notIsOnlyNumber({
    required String failedValue,
  }) = NotIsOnlyNumber<T>;
  const factory ValueFailure.missingStringLength({
    required String failedValue,
  }) = MissingIntLength<T>;
  const factory ValueFailure.spaces({
    required String failedValue,
  }) = Spaces<T>;
  const factory ValueFailure.exceedingStringLength({
    required String failedValue,
    required int max,
  }) = ExceedingStringLength<T>;
  const factory ValueFailure.withOutMinStringLength({
    required String failedValue,
    required int min,
  }) = WithOutMinStringLength<T>;
  const factory ValueFailure.invalidValue({
    required double failedValue,
  }) = InvalidValue<T>;
  const factory ValueFailure.multiline({
    required String failedValue,
  }) = Multiline<T>;
  const factory ValueFailure.invalidEmail({
    required String failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.invalidMonth({
    required String failedValue,
  }) = InvalidMonth<T>;
  const factory ValueFailure.invalidYear({
    required String failedValue,
  }) = InvalidYear<T>;
  const factory ValueFailure.exceedingIntLength({
    required int failedValue,
    required int max,
  }) = ExceedingIntLength<T>;
  const factory ValueFailure.invalidCpfOrCnpj({
    required String failedValue,
  }) = InvalidCpfOrCnpj<T>;
}
