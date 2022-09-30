part of 'user_form_bloc.dart';

@freezed
class UserFormState with _$UserFormState {
  factory UserFormState({
    required bool isLoading,
    required int totalSteps,
    required int actualStep,
    required List<Gender> genders,
    required bool isEditing,
    required User user,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required MaskedTextController cpfCodeController,
    required TextEditingController phoneNumberController,
    required MaskedTextController birthController,
    required Option<Either<UserFailure, Unit>> failureOrSuccess,
  }) = _Initial;

  factory UserFormState.initial() => UserFormState(
        isEditing: false,
        isLoading: false,
        actualStep: 0,
        totalSteps: 5,
        failureOrSuccess: none(),
        user: User.empty(),
        genders: [
          const Gender(
            id: 0,
            description: "Masculino",
          ),
          const Gender(
            id: 1,
            description: "Feminino",
          ),
          const Gender(
            id: 3,
            description: "Não Definido",
          )
        ],
        birthController: MaskedTextController(mask: '00/00/0000'),
        cpfCodeController: MaskedTextController(mask: '000.000.000-00'),
        nameController: TextEditingController(),
        phoneNumberController: MaskedTextController(mask: '(00) 00000-0000'),
        emailController: TextEditingController(),
      );
}
