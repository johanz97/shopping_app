import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/app/i_app_repository.dart';
import '../../../domain/parking_lot/i_parking_lot_repository.dart';
import '../../../domain/parking_lot/payment_request.dart';
import '../../../domain/parking_lot/payment_request_failure.dart';
import '../../../domain/parking_lot/users_device_info/users_device_info.dart';
import '../../../domain/ticket/ticket.dart';
import '../../../domain/ticket/ticket_failure.dart';
import '../../../domain/ticket/ticket_status/ticket_status.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../infrastructure/core/local_repository.dart';
import '../../../infrastructure/i_ticket_id_repository.dart';

part 'ticket_watcher_bloc.freezed.dart';
part 'ticket_watcher_event.dart';
part 'ticket_watcher_state.dart';

@injectable
class TicketWatcherBloc extends Bloc<TicketWatcherEvent, TicketWatcherState> {
  final ITicketIdRepository _ticketIdRepository;
  final IParkingLotRepository _parkingLotRepository;
  final IAppRepository _appRepository;
  TicketWatcherBloc(
    this._ticketIdRepository,
    this._parkingLotRepository,
    this._appRepository,
  ) : super(const TicketWatcherState.initial());

  @override
  Stream<TicketWatcherState> mapEventToState(TicketWatcherEvent gEvent) async* {
    yield* gEvent.map(
      watchStarted: (e) async* {
        yield const TicketWatcherState.loadInProgress();
        if (e.ticketId == "000000000000") {
          yield const TicketWatcherState.ticketNotFound();
          return;
        }
        await _parkingLotRepository.getParkingLotData();
        final ticketId = await _ticketIdRepository.getTicketId();

        if (e.ticketId != null || ticketId.isNotEmpty) {
          final isScanned =
              await _ticketIdRepository.saveTicketId(e.ticketId ?? ticketId);
          add(
            TicketWatcherEvent.ticketEitherRecived(
              await _parkingLotRepository.fetchTicketStatus(
                ticketId: e.ticketId ?? ticketId,
                scanning: isScanned,
              ),
              await _parkingLotRepository.getTicketDetails(
                ticketId: ticketId,
              ),
            ),
          );
        } else {
          yield const TicketWatcherState.initial();
        }
      },
      ticketEitherRecived: (e) async* {
        yield* e.faliureOrTicket.fold((l) async* {
          yield const TicketWatcherState.ticketNotFound();
        }, (ticket) async* {
          final details =
              e.faliureOrDetails.fold((failure) => null, (details) => details);
          if (ticket.isPaid || ticket.hasExited) {
            yield TicketWatcherState.paidTicket(ticket, details);
          } else {
            yield TicketWatcherState.notPaidTicket(ticket, details);
          }
        });
      },
      ticketRecived: (e) async* {
        if (e.ticketStatus.isPaid) {
          yield TicketWatcherState.paidTicket(
            e.ticketStatus,
            e.details,
          );
        } else {
          yield TicketWatcherState.notPaidTicket(
            e.ticketStatus,
            e.details,
          );
        }
      },
      finishFreeTime: (e) async* {
        add(
          TicketWatcherEvent.ticketEitherRecived(
            await _parkingLotRepository.fetchTicketStatus(
              ticketId: e.ticketNumber,
            ),
            await _parkingLotRepository.getTicketDetails(
              ticketId: e.ticketNumber,
            ),
          ),
        );
      },
      payTicket: (e) async* {
        yield const TicketWatcherState.paymentInProgress();
        final user = LocalRepository.getUserSerializer()!.toDomain();

        final privateIp = await _appRepository.getPrivateIp();
        final publicIp = await _appRepository.getPublicIp();

        final failureOrPayment = await _parkingLotRepository.authorizePayment(
          paymentRequest: PaymentRequest(
            creditCard: e.creditCard,
            ticketStatus: e.ticketStatus,
            user: user,
            usersDeviceInfo: UsersDeviceInfo(
              publicIp: publicIp,
              privateIp: privateIp,
            ),
          ),
        );
        yield failureOrPayment.fold(
          (failure) => TicketWatcherState.paymentFailure(failure),
          (paymentAuthorize) {
            return TicketWatcherState.paidTicket(
              e.ticketStatus.copyWith(
                paymentAuthorizationResponse: paymentAuthorize,
                status: TicketStatusEnum.paid,
              ),
              e.details,
            );
          },
        );
      },
      archiveTicket: (e) async* {
        yield const TicketWatcherState.initial();
        _ticketIdRepository.removeTicketId();
      },
    );
  }
}
