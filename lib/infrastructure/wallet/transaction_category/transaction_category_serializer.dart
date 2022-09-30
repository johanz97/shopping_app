import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/wallet/transaction_category/transaction_category.dart';

part 'transaction_category_serializer.freezed.dart';
part 'transaction_category_serializer.g.dart';

@freezed
class TransactionCategorySerializer with _$TransactionCategorySerializer {
  @JsonSerializable(createToJson: true)
  factory TransactionCategorySerializer({
    required String logo,
    required String name,
  }) = _TransactionCategorySerializer;

  const TransactionCategorySerializer._();

  factory TransactionCategorySerializer.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategorySerializerFromJson(json);

  TransactionCategory toDomain() => TransactionCategory(
        logo: logo,
        name: name,
      );
}
