import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info_failure.dart';
import '../../../domain/wallet/i_wallet_repository.dart';

part 'select_card_bloc.freezed.dart';
part 'select_card_event.dart';
part 'select_card_state.dart';

@injectable
class SelectCardBloc extends Bloc<SelectCardEvent, SelectCardState> {
  final IWalletRepository _walletRepository;
  SelectCardBloc(this._walletRepository) : super(SelectCardState.initial());

  @override
  Stream<SelectCardState> mapEventToState(SelectCardEvent gEvent) async* {
    yield* gEvent.map(
      selectCard: (e) async* {
        yield state.copyWith(
          creditCardInfo: e.creditCardInfo,
        );
      },
      initialize: (e) async* {
        yield state.copyWith(
          pageController: PageController(
            initialPage: e.creditCards.length,
          ),
          creditCards: e.creditCards,
        );
        add(Animate(e.creditCards.length));
      },
      animate: (e) async* {
        await Future.delayed(const Duration(milliseconds: 200));
        state.pageController!.animateToPage(
          e.length,
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceIn,
        );
      },
      updateList: (e) async* {
        final failureOrCards = _walletRepository.getCreditCards();
        yield failureOrCards.fold(
          (failure) => state.copyWith(
            creditCards: [],
          ),
          (cards) => state.copyWith(
            creditCards: cards,
            isLoading: false,
          ),
        );
      },
      deleteCreditCard: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrDeleteCard: optionOf(
            // _walletRepository.deleteCreditCard(
            //   creditCardInfo: state.creditCardInfo,
            // ),
            right([CreditCardInfo.test()]),
          ),
        );
      },
      getCreditCards: (e) async* {
        yield state.copyWith(
          isLoading: true,
        );

        final failureOrCreditCards = _walletRepository.getCreditCards();

        yield failureOrCreditCards.fold(
          (failure) => state.copyWith(
            creditCards: [],
          ),
          (cards) => state.copyWith(
            creditCards: cards,
            isLoading: false,
          ),
        );
      },
    );
  }
}
