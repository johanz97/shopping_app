part of 'user_form_bloc.dart';

@freezed
class UserFormEvent with _$UserFormEvent {
  const factory UserFormEvent.initialize(int index, User? user) = Initialize;
  const factory UserFormEvent.nextStep() = NextStep;
  const factory UserFormEvent.nameChanged(String name) = NameChanged;
  const factory UserFormEvent.cpfChanged(String cpf) = CpfChanged;
  const factory UserFormEvent.cellPhoneChanged(String phoneNumber) =
      CellPhoneChanged;
  const factory UserFormEvent.birthChanged(String birth) = BirthChanged;
  const factory UserFormEvent.genderChanged(Gender gender) = GenderChanged;
  const factory UserFormEvent.updateUserData() = _UpdateUserData;
  const factory UserFormEvent.backStep() = BackStep;
}
