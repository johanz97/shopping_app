import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/parking_lot/i_parking_lot_repository.dart';
import '../../../domain/ticket/ticket.dart';
import '../../../domain/ticket/ticket_failure.dart';

part 'tickets_archive_state.dart';
part 'tickets_archive_event.dart';
part 'tickets_archive_bloc.freezed.dart';

@injectable
class TicketsArchiveBloc
    extends Bloc<TicketsArchiveEvent, TicketsArchiveState> {
  final IParkingLotRepository _parkingLotRepository;
  TicketsArchiveBloc(this._parkingLotRepository)
      : super(const TicketsArchiveState.initial());

  @override
  Stream<TicketsArchiveState> mapEventToState(
    TicketsArchiveEvent gEvent,
  ) async* {
    yield* gEvent.map(
      getUserTickets: (e) async* {
        yield const TicketsArchiveState.loadInProgress();
        final failureOrTickets = await _parkingLotRepository.getUsersTickets();
        yield failureOrTickets.fold(
          (failure) => TicketsArchiveState.loadFailure(failure),
          (tickets) => TicketsArchiveState.userTickets(tickets),
        );
      },
    );
  }
}
