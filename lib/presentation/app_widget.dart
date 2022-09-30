import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './routes/router.gr.dart';
import '../aplication/app/app_bloc.dart';
import '../aplication/auth/auth_bloc.dart';
import '../injection.dart';
import 'core/theme_data.dart';

class AppWidget extends StatelessWidget {
  final _appRouter = AppRouter();
  AppWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      builder: () {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<AppBloc>()
                ..add(
                  const AppEvent.initializer(),
                ),
            ),
            BlocProvider(
              create: (context) => getIt<AuthBloc>(),
            ),
          ],
          child: MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            routerDelegate: AutoRouterDelegate(
              _appRouter,
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),
            title: 'Parking App',
            theme: AppTheme.lightTheme,
          ),
        );
      },
    );
  }
}
