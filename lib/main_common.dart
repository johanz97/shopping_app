import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/config_reader.dart';
import 'core/sentry_support.dart';
import 'domain/app/enviroment/env.dart' as tag;
import 'injection.dart';
import 'my_bloc_observer.dart';
import 'presentation/app_widget.dart';

Future<void> mainCommon(tag.EnvTag env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ConfigReader.initialize();
  configureInjection(Environment.prod);
  Intl.defaultLocale = 'en_US';
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  //Initialize the LocalStorage container
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('app');
  await Hive.openBox('userData');
  await Hive.openBox<Map>('credit_cards');
  await Hive.openBox('parkingLot');
  await Hive.openBox<Map>('genres');

  //Inicializo el watcher de los bloc
  Bloc.observer = MyBlocObserver();

  //Initialize the sentry support
  final sentryUrl = await SentrySupport.getSentryObservatoryUrl();
  runZonedGuarded(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryUrl;
      },
    );
    FlutterError.onError = (details) {
      if (kReleaseMode) {
        Sentry.captureException(details.exception, stackTrace: details.stack);
      }
    };
    runApp(const MyApp());
  }, (exception, stackTrace) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('pt')],
      path: 'resources/langs',
      useOnlyLangCode: true,
      fallbackLocale: const Locale('pt'),
      child: MaterialApp(
        title: 'Maceio Shopping',
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          curve: Curves.decelerate,
          splash: 'assets/img/splash.png',
          nextScreen: AppWidget(),
          splashTransition: SplashTransition.fadeTransition,
          splashIconSize: 400,
          duration: 100,
        ),
      ),
    );
  }
}
