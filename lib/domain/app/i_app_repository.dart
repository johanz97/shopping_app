import 'package:dartz/dartz.dart';

import 'enviroment/env.dart';
import 'enviroment/env_failure.dart';
import 'enviroments.dart';

abstract class IAppRepository {
  Future<Either<EnvFailure, Env>> getEnv(EnvTag envTag);
  Enviroments getEnvs();
  Future<Either<EnvFailure, Unit>> getAndSetAppId({Enviroments? enviroments});
  Future<String> getPublicIp();
  Future<String> getPrivateIp();
}
