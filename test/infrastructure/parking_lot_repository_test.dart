import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart' as injection;
import 'package:logger/logger.dart';
import 'package:parking_web_app_maicero_shop/domain/parking_lot/i_parking_lot_repository.dart';
import 'package:parking_web_app_maicero_shop/domain/ticket/ticket_status/ticket_status.dart';
import 'package:parking_web_app_maicero_shop/injection.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';

Future<void> main() async {
  configureInjection(injection.Environment.prod);
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('app');
  await Hive.openBox('parkingLot');
  getIt<Dio>().options.baseUrl = "https://api-dev.super.cash/v2/";
  getIt<Dio>().options.headers["X-Supercash-Marketplace-Id"] = 14824;
  getIt<Dio>().options.headers["X-Supercash-Store-Id"] = 14791;
  getIt<Dio>().options.headers["X-Supercash-App-Version"] = 1.0;
  getIt<Dio>().options.headers["X-Supercash-Uid"] = 15241;
  final _logger = getIt<Logger>();

  //Ticket status with fee test
  test('Ticket status with fee test', () async {
    try {
      final parkingLotRepository = getIt<IParkingLotRepository>();
      final ticketEither = await parkingLotRepository.fetchTicketStatus(
        ticketId: '111111000000',
      );
      assert(ticketEither.isRight());
      _logger.d('Ticket status with fee test was executed correctly');
    } on Exception catch (_) {
      _logger.e('Ticket status with fee test did not run correctly');
    }
  });

  //Save ticket status test
  test('Save ticket status test', () async {
    try {
      final parkingLotRepository = getIt<IParkingLotRepository>();
      final ticketStatus = TicketStatus(
        ticketId: '111111000000',
        entraceDate: DateTime.fromMillisecondsSinceEpoch(1641424306473).toUtc(),
        requestDate: DateTime.fromMillisecondsSinceEpoch(1641434651913).toUtc(),
        exitAllowedDate:
            DateTime.fromMillisecondsSinceEpoch(1641427906473).toUtc(),
        status: TicketStatusEnum.notPaid,
        parkingLotName: 'Maceió Shopping',
        gracePeriodMaxTime:
            DateTime.fromMillisecondsSinceEpoch(1641424486473).toUtc(),
      );
      final saveTicketEither = await parkingLotRepository.saveTicketStatus(
        ticketStatus: ticketStatus,
      );
      assert(saveTicketEither.isRight());
      _logger.d('Save ticket status test was executed correctly');
    } on Exception catch (_) {
      _logger.e('Save ticket status test did not run correctly');
    }
  });

  //Delete ticket status test
  test('Delete ticket status test', () async {
    try {
      final parkingLotRepository = getIt<IParkingLotRepository>();
      final deleteTicketEither = await parkingLotRepository.deleteTicketStatus(
        ticketId: '111111000000',
      );
      assert(deleteTicketEither.isRight());
      _logger.d('Delete ticket status test was executed correctly');
    } on Exception catch (_) {
      _logger.e('Delete ticket status test did not run correctly');
    }
  });

  //Ticket details test
  test('Ticket details test', () async {
    try {
      final parkingLotRepository = getIt<IParkingLotRepository>();
      final ticketDetailsEither =
          await parkingLotRepository.getTicketDetails(ticketId: '248342652982');
      assert(ticketDetailsEither.isRight());
      _logger.d('Ticket details test was executed correctly');
    } on Exception catch (_) {
      _logger.e('Ticket details test did not run correctly');
    }
  });

  //Get user tickets test
  test('Get user tickets test', () async {
    try {
      final parkingLotRepository = getIt<IParkingLotRepository>();
      final userTicketsEither = await parkingLotRepository.getUsersTickets();
      assert(userTicketsEither.isRight());
      _logger.d('Get user tickets test was executed correctly');
    } on Exception catch (_) {
      _logger.e('Get user tickets test did not run correctly');
    }
  });
}
