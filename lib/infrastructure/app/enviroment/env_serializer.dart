import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/enviroment/env.dart';

part 'env_serializer.freezed.dart';
part 'env_serializer.g.dart';

@freezed
class EnvSerializer with _$EnvSerializer {
  @JsonSerializable(createToJson: true)
  factory EnvSerializer({
    @JsonKey(name: "base_url_supercash_api")
        required String baseUrlSupercashApi,
    @JsonKey(name: "base_url_supercash_metadata")
        required String baseUrlSupercashMetadata,
    @JsonKey(name: "marketplace_metadata_api")
        required String marketplaceMetadataApi,
    @JsonKey(name: "public_ip_api") required String publicIpApi,
    required String whitelabel,
    @JsonKey(name: "support_cellphone") required String supportCellphone,
    @JsonKey(name: "support_email") required String supportEmail,
    @JsonKey(name: "discord_ios_support_chanel")
        required String discordIosSupportChanel,
    @JsonKey(name: "discord_android_support_chanel")
        required String discordAndroidSupportChanel,
    @JsonKey(name: "url_gitlab_issues") required String urlGitlabIssues,
    @JsonKey(name: "terms_of_use") required String termsOfUse,
    @JsonKey(name: "politic_of_privacity") required String politicOfPrivacity,
    required String timezoneLocation,
    required String url,
    required double appVersion,
    required bool enabled,
  }) = _EnvSerializer;

  const EnvSerializer._();

  factory EnvSerializer.fromJson(Map<String, dynamic> json) =>
      _$EnvSerializerFromJson(json);

  Env toDomain() => Env(
        baseUrlSupercashApi: baseUrlSupercashApi,
        baseUrlSupercashMetadata: baseUrlSupercashMetadata,
        marketplaceMetadataApi: marketplaceMetadataApi,
        publicIpApi: publicIpApi,
        whitelabel: whitelabel,
        supportCellphone: supportCellphone,
        supportEmail: supportEmail,
        discordIosSupportChanel: discordIosSupportChanel,
        discordAndroidSupportChanel: discordAndroidSupportChanel,
        urlGitlabIssues: urlGitlabIssues,
        termsOfUse: termsOfUse,
        politicOfPrivacity: politicOfPrivacity,
        timezoneLocation: timezoneLocation,
        url: url,
        appVersion: appVersion,
        enabled: enabled,
      );
}
