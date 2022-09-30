part of 'ticket_watcher_bloc.dart';

@freezed
class TicketWatcherEvent with _$TicketWatcherEvent {
  const factory TicketWatcherEvent.watchStarted({String? ticketId}) =
      Initialized;
  const factory TicketWatcherEvent.ticketEitherRecived(
    Either<TicketFailure, TicketStatus> faliureOrTicket,
    Either<TicketFailure, Ticket?> faliureOrDetails,
  ) = _TicketEitherRecived;
  const factory TicketWatcherEvent.ticketRecived(
    TicketStatus ticketStatus,
    Ticket? details,
  ) = _TicketRecived;
  const factory TicketWatcherEvent.finishFreeTime(String ticketNumber) =
      FinishFreeTime;
  const factory TicketWatcherEvent.payTicket(
    TicketStatus ticketStatus,
    CreditCardInfo creditCard,
    Ticket? details,
  ) = PayTicket;
  const factory TicketWatcherEvent.archiveTicket() = ArchiveTicket;
}
