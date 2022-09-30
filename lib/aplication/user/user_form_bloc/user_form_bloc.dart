import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../core/utils.dart';
import '../../../domain/user/gender/gender.dart';
import '../../../domain/user/phone_number/phone_number.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';
import '../../../presentation/core/text_edit_mask.dart';

part 'user_form_bloc.freezed.dart';
part 'user_form_event.dart';
part 'user_form_state.dart';

@injectable
class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  UserFormBloc() : super(UserFormState.initial());

  @override
  Stream<UserFormState> mapEventToState(UserFormEvent gEvent) async* {
    yield* gEvent.map(
      initialize: (e) async* {
        if (e.user != null) {
          yield state.copyWith(
            actualStep: e.index,
            isEditing: true,
            user: e.user!,
            nameController: TextEditingController(
              text: e.user!.name,
            ),
            emailController: TextEditingController(
              text: e.user!.preferredEmail.email,
            ),
            birthController: MaskedTextController(
              mask: '00/00/0000',
              text: DateFormat("dd/MM/yyyy").format(e.user!.birth!),
            ),
            cpfCodeController: MaskedTextController(
              mask: '000.000.000-00',
              text: e.user!.taxId,
            ),
            phoneNumberController: MaskedTextController(
              mask: '(00) 00000-0000',
              text: (e.user!.preferredPhoneNumber!.areaCode +
                      e.user!.preferredPhoneNumber!.number)
                  .toString(),
            ),
          );
        }
      },
      nextStep: (e) async* {
        if ((state.totalSteps - 1) > state.actualStep && !state.isEditing) {
          yield state.copyWith(
            actualStep: state.actualStep + 1,
          );
        } else {
          add(const _UpdateUserData());
        }
      },
      nameChanged: (e) async* {
        yield state.copyWith(
          user: state.user.copyWith(
            name: e.name,
          ),
        );
      },
      birthChanged: (e) async* {
        if (e.birth.length == 10) {
          yield state.copyWith(
            user: state.user.copyWith(
              birth: DateFormat('dd/MM/yyyy').parse(e.birth),
            ),
          );
        }
      },
      cellPhoneChanged: (e) async* {
        yield state.copyWith(
          user: state.user.copyWith(
            preferredPhoneNumber: PhoneNumber.empty().copyWith(
              number: formatPhoneInt(e.phoneNumber),
            ),
          ),
        );
      },
      cpfChanged: (e) async* {
        yield state.copyWith(
          user: state.user.copyWith(
            taxId: e.cpf,
          ),
        );
      },
      genderChanged: (e) async* {
        yield state.copyWith(
          user: state.user.copyWith(
            gender: e.gender,
          ),
        );
      },
      updateUserData: (e) async* {
        yield state.copyWith(
          isLoading: true,
        );
        await Future.delayed(const Duration(seconds: 2));
        yield state.copyWith(
          isLoading: false,
          failureOrSuccess: optionOf(
            right(unit),
          ),
        );
      },
      backStep: (e) async* {
        if (state.actualStep > 0) {
          yield state.copyWith(
            actualStep: state.actualStep - 1,
          );
        }
      },
    );
  }
}
