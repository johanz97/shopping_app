import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/validator.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../domain/wallet/credit_card_info/credit_card_info_failure.dart';
import '../../../presentation/core/text_edit_mask.dart';

part 'credit_card_form_bloc.freezed.dart';
part 'credit_card_form_event.dart';
part 'credit_card_form_state.dart';

@injectable
class CreditCardFormBloc
    extends Bloc<CreditCardFormEvent, CreditCardFormState> {
  CreditCardFormBloc() : super(CreditCardFormState.initial());

  @override
  Stream<CreditCardFormState> mapEventToState(
    CreditCardFormEvent gEvent,
  ) async* {
    yield* gEvent.map(
      initialized: (e) async* {
        if (e.card != null) {
          yield state.copyWith(
            isEditing: true,
            failureOrCreditCard: none(),
            failureOrUpdate: none(),
            holderName: e.card!.holderName,
            cardNumber: e.card!.cardNumber,
            dateExp: "${e.card!.cardMonth}/${e.card!.cardYear}",
            cardCvvNumber: e.card!.cardCVVNumber,
          );

          state.cardHolderNameController.text = e.card!.holderName;
          state.cardNumberController.text = e.card!.cardNumber;
          state.expiryDateController.text =
              "${e.card!.cardMonth}/${e.card!.cardYear}";
          state.cvvCodeController.text = e.card!.cardCVVNumber;
        }
      },
      nameChanged: (e) async* {
        yield state.copyWith(
          holderName: e.name,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      cardNumberChanged: (e) async* {
        yield state.copyWith(
          cardNumber: e.number,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      cardDateChanged: (e) async* {
        yield state.copyWith(
          dateExp: e.date,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      cvvCodeChanged: (e) async* {
        yield state.copyWith(
          cardCvvNumber: e.cvv,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      flipCard: (e) async* {
        yield state.copyWith(
          flipCard: !state.flipCard,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      validateData: (e) async* {
        final isValidCardNumber =
            Validator.validateCardNumber(state.cardNumber).isRight();
        final isValidNameHolder =
            Validator.validateName(state.holderName).isRight();
        final isValidDateExp =
            Validator.validateDateExp(state.dateExp).isRight();
        final isValidCvv =
            Validator.validateCvvCode(state.cardCvvNumber).isRight();

        yield state.copyWith(
          hasErrors: !(isValidCardNumber &&
              isValidNameHolder &&
              isValidDateExp &&
              isValidCvv),
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
      },
      save: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
        // Test logic without http request
        if (CreditCardInfo.test().cardNumber ==
            state.cardNumber.replaceAll(' ', '')) {
          await Future.delayed(const Duration(seconds: 1));
          yield state.copyWith(
            isLoading: true,
            failureOrUpdate: none(),
            failureOrCreditCard: optionOf(
              right(CreditCardInfo.test()),
            ),
          );
        } else {
          // logic with http request

        }
      },
      confirmedChanged: (e) async* {
        if (!state.hasErrors) {
          yield state.copyWith(
            isConfirmed: !state.isConfirmed,
            failureOrCreditCard: none(),
            failureOrUpdate: none(),
            showCheck: !state.isConfirmed,
          );
        }
      },
      showCheck: (e) async* {
        yield state.copyWith(
          showCheck: e.show,
          failureOrUpdate: none(),
          failureOrCreditCard: none(),
        );
      },
      update: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrCreditCard: none(),
          failureOrUpdate: none(),
        );
        // Test logic without http request
        if (CreditCardInfo.test().cardNumber ==
            state.cardNumber.replaceAll(' ', '')) {
          await Future.delayed(const Duration(seconds: 1));
          yield state.copyWith(
            isLoading: true,
            failureOrUpdate: optionOf(
              const Right(unit),
            ),
            failureOrCreditCard: none(),
          );
        } else {
          // logic with http request

        }
      },
    );
  }
}
