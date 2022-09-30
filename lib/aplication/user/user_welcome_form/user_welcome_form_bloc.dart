import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../infrastructure/core/local_repository.dart';

part 'user_welcome_form_state.dart';
part 'user_welcome_form_event.dart';
part 'user_welcome_form_bloc.freezed.dart';

@injectable
class UserWelcomeFormBloc
    extends Bloc<UserWelcomeFormEvent, UserWelcomeFormState> {
  UserWelcomeFormBloc() : super(UserWelcomeFormState.initial());

  @override
  Stream<UserWelcomeFormState> mapEventToState(
    UserWelcomeFormEvent gEvent,
  ) async* {
    yield* gEvent.map(
      nextStep: (e) async* {
        if (state.actualStep < state.totalStepts) {
          yield state.copyWith(
            actualStep: state.actualStep + 1,
          );
          LocalRepository.setIndexStepper(index: state.actualStep + 1);
        }
      },
      finishProcess: (e) async* {
        final user = LocalRepository.getUserSerializer();
        LocalRepository.setIsNewUser(
          key: user!.emailsSerializer.first.email,
          isNewUser: false,
        );
      },
      initialize: (e) async* {
        final index = LocalRepository.getIndexStepper();
        yield state.copyWith(actualStep: index);
      },
    );
  }
}
