import 'package:freezed_annotation/freezed_annotation.dart';

import '../ticket_status/ticket_status.dart';

part 'ticket_state.freezed.dart';

@freezed
class TicketState with _$TicketState {
  const factory TicketState({
    required DateTime at,
    required TicketStatusEnum state,
  }) = _TicketState;
}
