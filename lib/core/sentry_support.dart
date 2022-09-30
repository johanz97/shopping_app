import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yaml/yaml.dart';

class SentrySupport {
  const SentrySupport();

  //Get sentry url from pubspec.yaml
  static Future<String> getSentryObservatoryUrl() async {
    final pubspectData = await rootBundle.loadString("pubspec.yaml");
    final yaml = loadYaml(pubspectData);
    return yaml["supercash"]["platform"]["observability"]["sentryUrl"]
        .toString();
  }

  static Future<void> captureExeotion({
    required dynamic exception,
    required StackTrace stackTrace,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }

  static void addTag({required String key, required String tag}) {
    Sentry.configureScope((scope) => scope.setTag(key, tag));
  }

  static void removeTag({required String key}) {
    Sentry.configureScope((scope) => scope.removeTag(key));
  }

  static void sendUnexpectedError({
    required String msg,
    required StackTrace stackTrace,
    required Logger logger,
  }) {
    logger.e(msg);
    SentrySupport.captureExeotion(
      exception: msg,
      stackTrace: stackTrace,
    );
  }

  static void sendDioError({
    required dynamic e,
    required StackTrace stackTrace,
    required String errorLocation,
    required Logger logger,
  }) {
    final superCashException = e.response.data['SupercashException'];
    var msg =
        'description: ${superCashException['description']} error_code: ${superCashException['error_code']}';
    if (superCashException['additional_description'].toString() != '') {
      msg +=
          ' additional_description: ${superCashException['additional_description']}';
    }
    if (superCashException['additional_fields']['third_party_message'] !=
        null) {
      msg +=
          ' third_party_message: ${superCashException['additional_fields']['third_party_message']}';
    }
    msg += errorLocation;
    sendUnexpectedError(msg: msg, stackTrace: stackTrace, logger: logger);
    SentrySupport.addTag(
      key: "request.statusCode",
      tag: e.response.statusCode.toString(),
    );
  }
}
