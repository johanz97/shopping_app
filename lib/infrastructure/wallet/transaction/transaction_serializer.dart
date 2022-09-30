import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/wallet/transaction.dart';
import '../../ticket/ticket_state/ticket_state_serializer.dart';
import '../transaction_category/transaction_category_serializer.dart';

part 'transaction_serializer.freezed.dart';
part 'transaction_serializer.g.dart';

@freezed
class TransactionSerializer with _$TransactionSerializer {
  @JsonSerializable(explicitToJson: true)
  factory TransactionSerializer({
    required double value,
    required double cashback,
    required String description,
    required DateTime date,
    required List<TicketStateSerializer> statesSerializer,
    required TransactionCategorySerializer transactionCategorySerializer,
  }) = _TransactionSerializer;

  const TransactionSerializer._();

  factory TransactionSerializer.fromJson(Map<String, dynamic> json) =>
      _$TransactionSerializerFromJson(json);

  Transaction toDomain() => Transaction(
        value: value,
        cashback: cashback,
        description: description,
        date: date,
        states: statesSerializer.map((e) => e.toDomain()).toList(),
        transactionCategory: transactionCategorySerializer.toDomain(),
      );
}
