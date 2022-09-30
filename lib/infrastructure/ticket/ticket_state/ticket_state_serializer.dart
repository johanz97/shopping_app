import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/ticket/ticket_state/ticket_state.dart';
import '../../../domain/ticket/ticket_status/ticket_status.dart';

part 'ticket_state_serializer.freezed.dart';
part 'ticket_state_serializer.g.dart';

@freezed
class TicketStateSerializer with _$TicketStateSerializer {
  @JsonSerializable(createToJson: true)
  factory TicketStateSerializer({
    @JsonKey(name: 'date') required int at,
    required String state,
  }) = _TicketStateSerializer;

  const TicketStateSerializer._();

  factory TicketStateSerializer.fromJson(Map<String, dynamic> json) =>
      _$TicketStateSerializerFromJson(json);

  TicketState toDomain() => TicketState(
        at: DateTime.fromMillisecondsSinceEpoch(at),
        state: TicketStatusEx.toEnum[state]!,
      );
}
