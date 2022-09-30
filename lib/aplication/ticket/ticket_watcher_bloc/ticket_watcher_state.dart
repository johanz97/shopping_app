part of 'ticket_watcher_bloc.dart';

@freezed
class TicketWatcherState with _$TicketWatcherState {
  const factory TicketWatcherState.initial() = Initial;
  const factory TicketWatcherState.ticketNotFound() = TicketNotFound;
  const factory TicketWatcherState.notPaidTicket(
    TicketStatus ticket,
    Ticket? details,
  ) = _NotPaidTicket;
  const factory TicketWatcherState.paidTicket(
    TicketStatus ticket,
    Ticket? details,
  ) = _PaidTicket;
  const factory TicketWatcherState.loadInProgress() = _LoadInProgress;
  const factory TicketWatcherState.paymentInProgress() = _PaymentInProgress;
  const factory TicketWatcherState.loadFailure(TicketFailure failure) =
      _LoadFailure;

  const factory TicketWatcherState.paymentFailure(
    PaymentRequestFailure failure,
  ) = _PaymentFailure;
}
