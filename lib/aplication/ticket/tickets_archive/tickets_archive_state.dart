part of 'tickets_archive_bloc.dart';

@freezed
class TicketsArchiveState with _$TicketsArchiveState {
  const factory TicketsArchiveState.initial() = _Initial;
  const factory TicketsArchiveState.userTickets(List<Ticket> tickets) =
      _UserTickets;

  const factory TicketsArchiveState.loadInProgress() = _LoadInProgress;
  const factory TicketsArchiveState.loadFailure(TicketFailure failure) =
      _LoadFailure;
}
