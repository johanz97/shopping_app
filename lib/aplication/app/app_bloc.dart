import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../core/config_reader.dart';
import '../../domain/app/enviroment/env.dart';
import '../../domain/app/enviroment/env_failure.dart';
import '../../domain/app/i_app_repository.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

@injectable
class AppBloc extends Bloc<AppEvent, AppState> {
  final IAppRepository _appRepository;

  AppBloc(this._appRepository) : super(AppState.initial());

  @override
  Stream<AppState> mapEventToState(AppEvent gEvent) async* {
    yield* gEvent.map(
      initializer: (e) async* {
        final envTag = ConfigReader.getDefEnv();
        final failureOrEnviroment = await _appRepository.getEnv(envTag);
        final enviroments = _appRepository.getEnvs();
        await _appRepository.getAndSetAppId(enviroments: enviroments);
        // If we obtain an environment, we define it as the current environment.

        yield* failureOrEnviroment.fold((failure) async* {
          yield state;
        }, (env) async* {
          yield state.copyWith(
            actualEnv: env,
            actualEnvTag: envTag,
          );
        });
        // We send the option to display a screen message in case of error.
        yield state.copyWith(
          initFailureOrSuccessOption: optionOf(failureOrEnviroment),
        );
      },
      changeEnv: (e) async* {
        final failureOrEnviroment = await _appRepository.getEnv(e.env);
        yield failureOrEnviroment.fold(
          (failure) => state,
          (env) => state.copyWith(
            actualEnv: env,
            actualEnvTag: e.env,
          ),
        );
        yield state.copyWith(
          initFailureOrSuccessOption: optionOf(failureOrEnviroment),
        );
      },
    );
  }
}
