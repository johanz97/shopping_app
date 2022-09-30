import 'package:freezed_annotation/freezed_annotation.dart';

import '../ticket/ticket_state/ticket_state.dart';
import 'transaction_category/transaction_category.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required double value,
    double? cashback,
    required String description,
    required DateTime date,
    required List<TicketState> states,
    TransactionCategory? transactionCategory,
  }) = _Transaction;
}
