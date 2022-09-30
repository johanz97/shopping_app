part of 'instructions_steper_bloc.dart';

@freezed
class InstructionsSteperState with _$InstructionsSteperState {
  factory InstructionsSteperState({
    required int step,
    required int totalSteps,
    required List<String> images,
    required List<String> descriptions,
    required bool isNewUser,
  }) = _Initial;

  factory InstructionsSteperState.initial() => InstructionsSteperState(
        isNewUser: false,
        step: 0,
        totalSteps: 3,
        descriptions: [
          "ticket_scanner_tutorial.tuto_1".tr(),
          "ticket_scanner_tutorial.tuto_2".tr(),
          "ticket_scanner_tutorial.tuto_3".tr()
        ],
        images: [
          "assets/img/scan.png",
          "assets/img/pay.png",
          "assets/img/exit.png"
        ],
      );
}
