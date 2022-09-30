import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_category.freezed.dart';

@freezed
class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required String logo,
    required String name,
  }) = _TransactionCategory;
}
