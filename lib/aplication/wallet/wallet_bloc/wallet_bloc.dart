import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/parking_lot/i_parking_lot_repository.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../domain/wallet/i_wallet_repository.dart';
import '../../../domain/wallet/transaction.dart';

part 'wallet_bloc.freezed.dart';
part 'wallet_event.dart';
part 'wallet_state.dart';

@injectable
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final IWalletRepository _walletRepository;
  final IParkingLotRepository _parkingLotRepository;
  WalletBloc(this._walletRepository, this._parkingLotRepository)
      : super(const WalletState.initial());

  @override
  Stream<WalletState> mapEventToState(WalletEvent gEvent) async* {
    yield* gEvent.map(
      initialize: (e) async* {
        yield const WalletState.loadInProgress();
        await _parkingLotRepository.getParkingLotData();
        final failureOrCreditCards = _walletRepository.getCreditCards();
        final failureOrTransactions =
            await _parkingLotRepository.getUsersTickets();

        if (failureOrCreditCards.isRight() && failureOrTransactions.isRight()) {
          final creditCards = failureOrCreditCards.fold(
            (failure) => null,
            (creditCards) => creditCards,
          );

          final tickets = failureOrTransactions.fold(
            (failure) => null,
            (transactions) => transactions,
          );
          if (creditCards!.isEmpty) {
            yield const WalletState.newUser();
            return;
          }

          final transactions = tickets!.map((ticket) {
            ticket.states!.sort((a, b) => a.at.compareTo(b.at));
            return Transaction(
              value: ticket.totalPayment,
              description: 'Pagamento de estacionamento',
              date: ticket.createdAt,
              states: ticket.states!,
            );
          }).toList();

          yield WalletState.success(
            creditCards: creditCards.isEmpty
                ? [
                    CreditCardInfo.test(),
                  ]
                : creditCards,
            transaction: transactions,
          );
        } else {
          yield const WalletState.loadFailure();
        }
      },
    );
  }
}
