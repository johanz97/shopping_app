import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

import '../../core/device_info.dart';
import '../../domain/app/enviroment/env.dart';
import '../../domain/app/enviroment/env_failure.dart';
import '../../domain/app/enviroments.dart';
import '../../domain/app/i_app_repository.dart';
import '../core/local_repository.dart';
import 'enviroments/enviroments_serializer.dart';

@LazySingleton(as: IAppRepository)
class AppRepository implements IAppRepository {
  final Dio _dio;
  final Logger _logger;
  static const getEnvConf = "https://apis.super.cash/marketplaces/2/config";

  AppRepository(this._dio, this._logger);
  /*
  It can return a failure or an environment sent from the server where we will
  verify if the environments have changed in the server by verifying the Etag,
  where if it has changed we get it from the server otherwise from the LocalStorage.
  */
  @override
  Future<Either<EnvFailure, Env>> getEnv(EnvTag defEnv) async {
    Env? enviroment;
    String? fetchedFrom;
    String? currentEtagHash;
    try {
      //There is an environment change sent by the server so update LocalStorage.
      _logger.d('Obtaining environment: $defEnv');
      currentEtagHash = LocalRepository.getEtag();
      final conditionResponse = await _dio.get(
        getEnvConf,
        options: Options(
          headers: {"If-None-Match": currentEtagHash},
        ),
      );
      if (conditionResponse.statusCode == 200) {
        final enviromentsSerializer = EnviromentsSerializer.fromJson(
          conditionResponse.data as Map<String, dynamic>,
        );
        LocalRepository.setAllEnviroments(
          enviromentsSerializer,
        );
        _dio.options.headers["X-Supercash-Marketplace-Id"] =
            enviromentsSerializer.marketplaceId;
        currentEtagHash = conditionResponse.headers["etag"]!.first;
        LocalRepository.setEtag(currentEtagHash);
        fetchedFrom = "REMOTE";
        if (defEnv == EnvTag.dev) {
          enviroment = enviromentsSerializer.toDomain().env['dev'];
        } else if (defEnv == EnvTag.stg) {
          enviroment = enviromentsSerializer.toDomain().env['stg'];
        } else {
          enviroment = enviromentsSerializer.toDomain().env['prd'];
        }
      }
      _logger.d(
        "Loaded config $currentEtagHash setting Env=${defEnv.toString().split(".").last} from $fetchedFrom",
      );
      _dio.options.baseUrl = enviroment!.baseUrlSupercashApi;

      return right(enviroment);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error}",
          );
          return left(EnvFailure.serverErrorDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error}",
          );
          return left(EnvFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 304) {
          //There is no change of environment, so the one stored in the LocalStorage must be taken.
          fetchedFrom = "CACHE";
          final EnviromentsSerializer? enviromentsSerializer =
              LocalRepository.getEnviroments();
          _dio.options.headers["X-Supercash-Marketplace-Id"] =
              enviromentsSerializer!.marketplaceId;
          if (defEnv == EnvTag.dev) {
            enviroment = enviromentsSerializer.toDomain().env['dev'];
          } else if (defEnv == EnvTag.stg) {
            enviroment = enviromentsSerializer.toDomain().env['stg'];
          } else {
            enviroment = enviromentsSerializer.toDomain().env['prd'];
          }
          _logger.d(
            "Loaded config $currentEtagHash setting Env=${defEnv.toString().split(".").last} from $fetchedFrom",
          );
          _dio.options.baseUrl = enviroment!.baseUrlSupercashApi;
          return right(enviroment);
        } else if (e.response!.statusCode == 500) {
          //A server error occurred.
          _logger.e('A server error occurred');
          return left(EnvFailure.serverErrorDown());
        } else {
          //An unexpected error occurred
          _logger.e('An unexpected error occurred');
          return left(EnvFailure.unexpected());
        }
      }
    }
  }

  //This function allows us to take the settings of the app's headers.
  @override
  Future<Either<EnvFailure, Unit>> getAndSetAppId({
    Enviroments? enviroments,
  }) async {
    try {
      _logger.d('Obtaining and saving the appId');
      _dio.options.headers["X-Supercash-Marketplace-Id"] =
          enviroments!.marketplaceId;
      _dio.options.headers["Accept-Language"] = 'pt-BR';
      _dio.options.headers["User-Agent"] = await DeviceInfo.getUserAgent();
      _dio.options.headers["X-Supercash-App-Version"] = 2.0;

      _logger.i("HEADER ATUALIZADO ${_dio.options.headers}");
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error}",
          );
          return left(EnvFailure.serverErrorDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error}",
          );
          return left(EnvFailure.notInternet());
        }
      } else {
        _logger.e(
          'An error occurred when obtaining the AppId: ${e.message} in the function: getAndSetAppId() on AppRepository',
        );
        return left(EnvFailure.unexpected());
      }
    }
  }

  @override
  Enviroments getEnvs() {
    final allEnvs = LocalRepository.getEnviroments();
    return allEnvs!.toDomain();
  }

  @override
  Future<String> getPublicIp() async {
    const String unknownIp = '0.0.0.0';
    try {
      final wifiIP = await WifiInfoPlugin.wifiDetails;

      if (wifiIP == null) return unknownIp;
      return wifiIP.ipAddress;
    } catch (e) {
      _logger.e("Could not obtain the public IP", e);
      return unknownIp;
    }
  }

  @override
  Future<String> getPrivateIp() async {
    _logger.d('Obtendo wifi do usuario');
    const String unknownIp = '0.0.0.0';

    try {
      final wifiIP = await WifiInfoPlugin.wifiDetails;

      if (wifiIP == null) return unknownIp;

      _logger.d('ip local $wifiIP');

      return wifiIP.routerIp;
    } on Exception catch (e) {
      _logger.e("Could not obtain the private IP", e);
      return unknownIp;
    }
  }
}
