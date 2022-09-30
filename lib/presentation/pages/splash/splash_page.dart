import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../aplication/app/app_bloc.dart';
import '../../../aplication/auth/auth_bloc.dart';

import '../../routes/router.gr.dart';
import 'widgets/auth_error.dart';
import 'widgets/load_envs_fail.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        state.initFailureOrSuccessOption.fold(() {}, (either) {
          either.fold(
            (failure) => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              builder: (context) {
                return LoadEnvsFail(
                  reload: () => context.read<AppBloc>().add(
                        const AppEvent.initializer(),
                      ),
                );
              },
            ),
            (env) {
              context.read<AuthBloc>().add(
                    const AuthEvent.checkSession(),
                  );
            },
          );
        });
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            authenticated: (isNewUser) {
              if (isNewUser) {
                context.router.pushAndPopUntil(
                  const UserWelcomeFormRoute(),
                  predicate: (e) => false,
                );
              } else {
                context.router.pushAndPopUntil(
                  HomeTicketRoute(),
                  predicate: (e) => false,
                );
              }
            },
            unauthenticated: () {
              context.router.pushAndPopUntil(
                const WelcomeRoute(),
                predicate: (e) => false,
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeMap(
            initial: (_) => const Scaffold(),
            modeFailure: (failure) => AuthError(
              reload: () => context.read<AuthBloc>().add(
                    const AuthEvent.checkSession(),
                  ),
            ),
            loading: (_) => Scaffold(
              body: Center(
                child: SizedBox(
                  height: 400.h,
                  width: 400.h,
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                  ),
                ),
              ),
            ),
            orElse: () => const Scaffold(),
          );
        },
      ),
    );
  }
}
