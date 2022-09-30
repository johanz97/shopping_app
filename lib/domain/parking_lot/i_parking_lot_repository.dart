import 'package:dartz/dartz.dart';

import '../ticket/ticket.dart';
import '../ticket/ticket_failure.dart';
import '../ticket/ticket_status/ticket_status.dart';
import 'payment_authorization_response/payment_authorization_response.dart';
import 'payment_request.dart';
import 'payment_request_failure.dart';

abstract class IParkingLotRepository {
  Future<Either<PaymentRequestFailure, PaymentAuthorizationResponse?>>
      authorizePayment({
    required PaymentRequest paymentRequest,
  });
  Future<Either<TicketFailure, Unit>> deleteTicketStatus({
    required String ticketId,
  });
  Future<Either<PaymentRequestFailure, Unit>> getParkingLotData();
  Future<Either<TicketFailure, Ticket?>> getTicketDetails({
    required String ticketId,
  });
  Future<Either<TicketFailure, List<Ticket>>> getUsersTickets();
  Future<Either<TicketFailure, List<TicketStatus>>> readTicketStatusList();
  Future<Either<TicketFailure, Unit>> saveTicketStatus({
    required TicketStatus ticketStatus,
  });
  Future<Either<TicketFailure, TicketStatus>> fetchTicketStatus({
    required String ticketId,
    bool scanning = false,
  });
}
