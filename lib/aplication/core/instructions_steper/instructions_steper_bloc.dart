import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../infrastructure/core/local_repository.dart';

part 'instructions_steper_bloc.freezed.dart';
part 'instructions_steper_event.dart';
part 'instructions_steper_state.dart';

@injectable
class InstructionsSteperBloc
    extends Bloc<InstructionsSteperEvent, InstructionsSteperState> {
  InstructionsSteperBloc() : super(InstructionsSteperState.initial());
  @override
  Stream<InstructionsSteperState> mapEventToState(
    InstructionsSteperEvent gEvent,
  ) async* {
    yield* gEvent.map(
      initialize: (e) async* {
        final user = LocalRepository.getUserSerializer();
        final isNewUser =
            LocalRepository.getIsNewUser(user!.emailsSerializer.first.email);
        if (isNewUser) {
          state.images.insert(
            0,
            "assets/img/advertencia.png",
          );
          state.descriptions.insert(
            0,
            "ticket_scanner_tutorial.tuto_4".tr(),
          );
        }

        yield state.copyWith(
          totalSteps: isNewUser ? 4 : 3,
          isNewUser: isNewUser,
        );
      },
      nextStep: (e) async* {
        yield state.copyWith(
          step: e.step,
        );
      },
    );
  }
}
