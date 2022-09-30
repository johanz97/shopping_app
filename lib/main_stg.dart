import 'domain/app/enviroment/env.dart';
import 'main_common.dart';

Future<void> main() async {
  await mainCommon(EnvTag.stg);
}
