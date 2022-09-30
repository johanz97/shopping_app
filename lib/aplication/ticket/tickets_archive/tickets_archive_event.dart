part of 'tickets_archive_bloc.dart';

@freezed
class TicketsArchiveEvent with _$TicketsArchiveEvent {
  const factory TicketsArchiveEvent.getUserTickets() = GetUserTickets;
}
