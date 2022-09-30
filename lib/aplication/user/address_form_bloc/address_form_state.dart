part of 'address_form_bloc.dart';

@freezed
class AddressFormState with _$AddressFormState {
  factory AddressFormState({
    required bool isLoading,
    required int totalSteps,
    required int actualStep,
    required Address address,
    required Option<Either<UserFailure, Address>> failureOrAddress,
    required Option<Either<UserFailure, User>> failureOrUser,
    required TextEditingController cepController,
    required TextEditingController streetController,
    required TextEditingController complementController,
    required TextEditingController numberController,
    required TextEditingController cityController,
    required TextEditingController stateController,
    required TextEditingController neighborhoodController,
    required TextEditingController countryController,
    required TextEditingController nicknameController,
  }) = _Initial;

  factory AddressFormState.initial() => AddressFormState(
        isLoading: false,
        totalSteps: 9,
        actualStep: 0,
        address: Address.empty(),
        failureOrAddress: none(),
        failureOrUser: none(),
        cepController: TextEditingController(),
        cityController: TextEditingController(),
        complementController: TextEditingController(),
        countryController: TextEditingController(),
        neighborhoodController: TextEditingController(),
        nicknameController: TextEditingController(),
        numberController: TextEditingController(),
        stateController: TextEditingController(),
        streetController: TextEditingController(),
      );
}
