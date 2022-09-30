part of 'address_form_bloc.dart';

@freezed
class AddressFormEvent with _$AddressFormEvent {
  const factory AddressFormEvent.initialize({
    required bool isFirst,
    required int index,
    Address? address,
  }) = Initialize;
  const factory AddressFormEvent.cepChanged(String cep) = CepChanged;
  const factory AddressFormEvent.addressChanged(String address) =
      AddressChanged;
  const factory AddressFormEvent.complementChanged(String complement) =
      ComplementChanged;
  const factory AddressFormEvent.numberChanged(String number) = NumberChanged;
  const factory AddressFormEvent.neighborhoodChanged(String neighborhood) =
      NeighborhoodChanged;
  const factory AddressFormEvent.cityChanged(String city) = CityChanged;
  const factory AddressFormEvent.stateChanged(String state) = StateChanged;
  const factory AddressFormEvent.nickNameChanged(String nickname) =
      NicknameChanged;
  const factory AddressFormEvent.isPreferedChanged({required bool isPrefered}) =
      IsPreferedChanged;
  const factory AddressFormEvent.save() = _Save;
  const factory AddressFormEvent.nextStep() = NextStep;
  const factory AddressFormEvent.incrementStep() = IncrementStep;
  const factory AddressFormEvent.getAddressFronCep() = _GetAddressFronCep;
  const factory AddressFormEvent.backStep() = BackStep;
}
