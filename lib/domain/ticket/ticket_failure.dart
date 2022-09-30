import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_failure.freezed.dart';

//Definition of existing errors in the ticket object
@freezed
class TicketFailure with _$TicketFailure {
  factory TicketFailure.notInternet() = NotInternet;
  factory TicketFailure.serverIsDown() = ServerIsDown;
  factory TicketFailure.timeLimitExceeded() = TimeLimitExceeded;
  factory TicketFailure.unexpected() = Unexpected;
  factory TicketFailure.ticketEmpty() = TicketEmpty;
  factory TicketFailure.ticketNotFound(String ticketNumber) = TicketNotFound;
  factory TicketFailure.ticketIncorrect() = TicketIncorrect;
}
