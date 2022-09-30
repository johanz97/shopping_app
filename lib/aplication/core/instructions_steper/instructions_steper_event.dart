part of 'instructions_steper_bloc.dart';

@freezed
class InstructionsSteperEvent with _$InstructionsSteperEvent {
  const factory InstructionsSteperEvent.initialize() = Initialize;
  const factory InstructionsSteperEvent.nextStep(int step) = NextStep;
}
