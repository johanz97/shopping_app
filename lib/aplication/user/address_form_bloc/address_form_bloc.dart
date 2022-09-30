import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/user/address/address.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';

part 'address_form_bloc.freezed.dart';
part 'address_form_event.dart';
part 'address_form_state.dart';

@injectable
class AddressFormBloc extends Bloc<AddressFormEvent, AddressFormState> {
  AddressFormBloc() : super(AddressFormState.initial());

  @override
  Stream<AddressFormState> mapEventToState(AddressFormEvent gEvent) async* {
    yield* gEvent.map(
      nextStep: (e) async* {
        if (state.actualStep == 0) {
          add(const _GetAddressFronCep());
        } else if (state.actualStep == (state.totalSteps - 1)) {
          add(const _Save());
        } else {
          add(const IncrementStep());
        }
      },
      incrementStep: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          actualStep: state.actualStep + 1,
        );
      },
      cepChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            zipcode: e.cep,
          ),
        );
      },
      getAddressFronCep: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          isLoading: true,
        );

        final testUser = User.test();
        if (testUser.preferredAddress!.zipcode == state.address.zipcode) {
          // Test logic withOut http request
          await Future.delayed(const Duration(seconds: 1));

          yield state.copyWith(
            isLoading: false,
            failureOrUser: none(),
            failureOrAddress: optionOf(
              right(
                testUser.preferredAddress!,
              ),
            ),
            address: testUser.preferredAddress!,
          );
        } else {
          // Logic with http request
        }
      },
      addressChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            street: e.address,
          ),
        );
      },
      complementChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            complement: e.complement,
          ),
        );
      },
      numberChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            number: e.number,
          ),
        );
      },
      neighborhoodChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            neighborhood: e.neighborhood,
          ),
        );
      },
      cityChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            city: e.city,
          ),
        );
      },
      stateChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            state: e.state,
          ),
        );
      },
      nickNameChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            nickname: e.nickname,
          ),
        );
      },
      isPreferedChanged: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          address: state.address.copyWith(
            preferred: e.isPrefered,
          ),
        );
      },
      save: (e) async* {
        yield state.copyWith(
          failureOrAddress: none(),
          failureOrUser: none(),
          isLoading: true,
        );

        final testUser = User.test();

        if (testUser.preferredAddress!.zipcode == state.address.zipcode) {
          // Test logic withOut http request
          await Future.delayed(const Duration(seconds: 1));
          yield state.copyWith(
            isLoading: false,
            failureOrAddress: none(),
            failureOrUser: optionOf(
              right(
                testUser,
              ),
            ),
          );
        } else {
          // Logic with http request
        }
      },
      initialize: (e) async* {
        yield state.copyWith(
          totalSteps: e.isFirst ? 8 : 9,
        );
        if (e.address != null) {
          yield state.copyWith(
            actualStep: e.index,
            address: e.address ?? Address.empty(),
            cepController: TextEditingController(
              text: e.address!.zipcode,
            ),
            cityController: TextEditingController(
              text: e.address!.city,
            ),
            complementController: TextEditingController(
              text: e.address!.complement,
            ),
            countryController: TextEditingController(
              text: e.address!.country.name,
            ),
            neighborhoodController: TextEditingController(
              text: e.address!.neighborhood,
            ),
            nicknameController: TextEditingController(
              text: e.address!.nickname,
            ),
            numberController: TextEditingController(
              text: e.address!.number,
            ),
            stateController: TextEditingController(
              text: e.address!.state,
            ),
            streetController: TextEditingController(
              text: e.address!.street,
            ),
          );
        }
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
