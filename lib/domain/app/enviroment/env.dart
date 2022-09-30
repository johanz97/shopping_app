import 'package:freezed_annotation/freezed_annotation.dart';

part 'env.freezed.dart';

@freezed
class Env with _$Env {
  const factory Env({
    required String baseUrlSupercashApi,
    required String baseUrlSupercashMetadata,
    required String marketplaceMetadataApi,
    required String publicIpApi,
    required String whitelabel,
    required String supportCellphone,
    required String supportEmail,
    required String discordIosSupportChanel,
    required String discordAndroidSupportChanel,
    required String urlGitlabIssues,
    required String termsOfUse,
    required String politicOfPrivacity,
    required String timezoneLocation,
    required String url,
    required double appVersion,
    required bool enabled,
  }) = _Env;
}

enum EnvTag { dev, prod, stg }
