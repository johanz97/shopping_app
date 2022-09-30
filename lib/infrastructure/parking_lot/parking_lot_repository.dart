import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../core/utils.dart';
import '../../domain/parking_lot/i_parking_lot_repository.dart';
import '../../domain/parking_lot/payment_authorization_response/payment_authorization_response.dart';
import '../../domain/parking_lot/payment_request.dart';
import '../../domain/parking_lot/payment_request_failure.dart';
import '../../domain/ticket/ticket.dart';
import '../../domain/ticket/ticket_failure.dart';
import '../../domain/ticket/ticket_status/ticket_status.dart';
import '../core/local_repository.dart';
import '../ticket/ticket_serializer.dart';
import '../ticket/ticket_status/ticket_status_serializer.dart';
import 'payment_authorization_response/payment_authorization_response_serializer.dart';
import 'payment_request/payment_request_serializer.dart';
import 'store/store_serializer.dart';

@LazySingleton(as: IParkingLotRepository)
class ParkingLotRepository implements IParkingLotRepository {
  late String _baseURL;
  final Dio _dio;
  final Logger _logger;

  ParkingLotRepository(
    this._logger,
    this._dio,
  ) {
    _baseURL = '${_dio.options.baseUrl}parkinglots';
  }

  //Allows you to save the list of tickets in the local repository.
  Either<TicketFailure, Unit> _saveTicketsList(
    List<TicketStatus> ticketsList,
  ) {
    _logger.d('saving new ticket list id');
    try {
      final List<String> ticketsId = [];
      for (final ticket in ticketsList) {
        ticketsId.add(ticket.ticketId);
      }
      LocalRepository.setTicketStatusList(ticketsMapList: ticketsId);
      _logger.d('New ticket list id saved: $ticketsId');
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function _saveTicketsList() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Allows to obtain the authorization of payment.
  @override
  Future<Either<PaymentRequestFailure, PaymentAuthorizationResponse?>>
      authorizePayment({
    required PaymentRequest paymentRequest,
  }) async {
    final postPaymentAuthorization =
        '$_baseURL/${_dio.options.headers['X-Supercash-Store-Id']}/tickets/${paymentRequest.ticketStatus.ticketId}/pay';

    final transactionId = Utils.generateId();
    final headers = {'X-Supercash-Tid': transactionId};

    final paymentRequestSerializable =
        PaymentRequestSerializer.fromDomain(paymentRequest);
    final body = paymentRequestSerializable.toMap();

    _logger.d('enviando body $body para $postPaymentAuthorization');

    try {
      final response = await _dio.post(
        postPaymentAuthorization,
        data: json.encode(body),
        options: Options(contentType: 'application/json', headers: headers),
      );
      final data = response.data['status'] as Map<String, dynamic>;
      PaymentAuthorizationResponse? payment;
      if (data.isNotEmpty) {
        payment = PaymentAuthorizationResponseSerializer.fromJson(
          data,
        ).toDomain();
      } else {
        payment = null;
      }
      _logger.d('Payment response: $payment');
      return right(payment);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: authorizePayment() on parking_lot_repository",
          );
          return left(PaymentRequestFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: authorizePayment() on parking_lot_repository",
          );
          return left(PaymentRequestFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: authorizePayment()`
          _logger.e(
            'Critical server error: ${e.message} in the function: authorizePayment() on parking_lot_repository',
          );
          return left(PaymentRequestFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: authorizePayment() on parking_lot_repository',
          );
          return left(PaymentRequestFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function authorizePayment() on parking_lot_repository',
      );
      return left(PaymentRequestFailure.unexpected());
    }
  }

  //Gets the data from the parking_lot.
  @override
  Future<Either<PaymentRequestFailure, Unit>> getParkingLotData() async {
    _logger.d('Loading parking lot data');
    final markId = _dio.options.headers["X-Supercash-Marketplace-Id"];
    final url = "marketplaces/$markId/categories/estacionamento/stores";

    try {
      final response = await _dio.get(url);
      final store = StoreSerializer.fromJson(
        (response.data).first as Map<String, dynamic>,
      ).toDomain();
      _dio.options.headers['X-Supercash-Store-Id'] = store.id;

      _logger.d(
        'parking lot loaded: ${(response.data).first as Map<String, dynamic>}',
      );
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getParkingLotData() on parking_lot_repository",
          );
          return left(PaymentRequestFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getParkingLotData() on parking_lot_repository",
          );
          return left(PaymentRequestFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: getParkingLotData()`
          _logger.e(
            'Critical server error: ${e.message} in the function: getParkingLotData() on parking_lot_repository',
          );
          return left(PaymentRequestFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getParkingLotData() on parking_lot_repository',
          );
          return left(PaymentRequestFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getParkingLotData() on parking_lot_repository',
      );
      return left(PaymentRequestFailure.unexpected());
    }
  }

  //Obtains fee services.
  Future<double> _getServiceFee() async {
    final serviceFeeUrl =
        '$_baseURL/${_dio.options.headers['X-Supercash-Store-Id']}/payments/servicefee';
    final transactionId = Utils.generateId();
    final headers = {'X-Supercash-Tid': transactionId};
    _logger.d('Getting service fee');
    Response<dynamic>? result;
    try {
      result = await _dio.get(
        serviceFeeUrl,
        options: Options(contentType: "application/json", headers: headers),
      );
      _logger.d('service fee: ${result.data['service_fee']}');
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getServiceFee() on parking_lot_repository",
          );
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getServiceFee() on parking_lot_repository",
          );
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: getServiceFee()`
          _logger.e(
            'Critical server error: ${e.message} in the function: getServiceFee() on parking_lot_repository',
          );
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getServiceFee() on parking_lot_repository',
          );
        }
      }
      throw Exception();
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getServiceFee() on parking_lot_repository',
      );
      throw Exception();
    }
    return result.data['service_fee']?.toDouble() / 100 as double;
  }

  //Gets the detail of a ticket which is searched by its id.
  @override
  Future<Either<TicketFailure, Ticket?>> getTicketDetails({
    required String ticketId,
  }) async {
    _logger.d('Getting the ticket detail');
    try {
      final transactionId = Utils.generateId();
      final headers = {'X-Supercash-Tid': transactionId};
      final ticketsUrl =
          "$_baseURL/${_dio.options.headers['X-Supercash-Store-Id']}/tickets";
      final response = await _dio.get(
        ticketsUrl,
        queryParameters: {"ticket_number": ticketId},
        options: Options(contentType: "application/json", headers: headers),
      );
      final data = response.data as List;
      List<Ticket> ticketsList = [];
      if (data.isNotEmpty) {
        final userId = data.first['states'].first['userId'];
        final List<Map<String, dynamic>> tickets = data.map((ticket) {
          ticket.addAll({'userId': userId});
          return ticket as Map<String, dynamic>;
        }).toList();
        ticketsList = tickets
            .map(
              (ticket) => TicketSerializer.fromJson(ticket).toDomain(),
            )
            .toList();
        _logger.d('Ticket detail obtained: ${ticketsList.first}');
        return right(ticketsList.first);
      } else {
        _logger.e('No ticket details');
        return right(null);
      }
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getTicketDetails() on parking_lot_repository",
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getTicketDetails() on parking_lot_repository",
          );
          return left(TicketFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: getTicketDetails()`
          _logger.e(
            'Critical server error: ${e.message} in the function: getTicketDetails() on parking_lot_repository',
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getTicketDetails() on parking_lot_repository',
          );
          return left(TicketFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getTicketDetails() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Gets the user's ticket list.
  @override
  Future<Either<TicketFailure, List<Ticket>>> getUsersTickets() async {
    final ticketsUrl =
        "$_baseURL/${_dio.options.headers['X-Supercash-Store-Id']}/tickets";

    final transactionId = Utils.generateId();
    final headers = {'X-Supercash-Tid': transactionId};
    _logger.d('Obtaining user tickets');
    try {
      final response = await _dio.get(
        ticketsUrl,
        options: Options(contentType: "application/json", headers: headers),
      );
      final data = response.data as List;
      List<Ticket> ticketsList = [];
      if (data.isNotEmpty) {
        final userId = data.first['states'].first['userId'];
        final List<Map<String, dynamic>> tickets = data.map((ticket) {
          ticket.addAll({'userId': userId});
          return ticket as Map<String, dynamic>;
        }).toList();
        ticketsList = tickets
            .map(
              (ticket) =>
                  TicketSerializer.fromJson(Map<String, dynamic>.from(ticket))
                      .toDomain(),
            )
            .toList();
      }
      _logger.d('Ticket list obtained: $ticketsList');
      return right(ticketsList);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getUsersTickets() on parking_lot_repository",
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getUsersTickets() on parking_lot_repository",
          );
          return left(TicketFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: getUsersTickets()`
          _logger.e(
            'Critical server error: ${e.message} in the function: getUsersTickets() on parking_lot_repository',
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getUsersTickets() on parking_lot_repository',
          );
          return left(TicketFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getUsersTickets() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Allows you to read the list of ticket statuses
  @override
  Future<Either<TicketFailure, List<TicketStatus>>>
      readTicketStatusList() async {
    final ticketIds = LocalRepository.getTicketStatusList();
    final ticketsList = <TicketStatus>[];
    _logger.d('Reading the ticket status list');
    try {
      if (ticketIds != null) {
        for (final idTicket in ticketIds) {
          final ticketData = await _ticketStatus(ticketId: idTicket);
          if (ticketData.status.value != 'PAID') {
            ticketsList.add(ticketData);
          }
        }
        _logger.d('Ticket status list: $ticketsList');
      } else {
        _logger.d('No tickets saved');
      }
      return right(ticketsList);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function readTicketStatusList() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Allows you to save the status of a ticket.
  @override
  Future<Either<TicketFailure, Unit>> saveTicketStatus({
    required TicketStatus ticketStatus,
  }) async {
    _logger.d('Saving the ticket status');
    try {
      final data = await readTicketStatusList();
      final ticketsList =
          data.fold((l) => null, (ticketStatusList) => ticketStatusList);
      if (ticketsList != null) {
        bool existe = false;
        for (final ticket in ticketsList) {
          if (ticket.ticketId == ticketStatus.ticketId) {
            existe = true;
          }
        }
        if (!existe) {
          ticketsList.add(ticketStatus);
          _logger.d('Ticket status saved: $ticketStatus');
        } else {
          _logger.e('Ticket status information already exists: $ticketStatus');
        }
        _saveTicketsList(ticketsList);
      } else {
        _logger.e('Ticket status not saved');
      }
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function saveTicketStatus() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Removes the status of a ticket which is searched by its id.
  @override
  Future<Either<TicketFailure, Unit>> deleteTicketStatus({
    required String ticketId,
  }) async {
    _logger.d('Deleting ticket status');
    try {
      final data = await readTicketStatusList();
      final ticketsList =
          data.fold((l) => null, (ticketStatusList) => ticketStatusList);
      if (ticketsList != null) {
        ticketsList
            .removeWhere((eachTicket) => eachTicket.ticketId == ticketId);
        _saveTicketsList(ticketsList);
        _logger.d('Ticket status deleted');
      } else {
        _logger.e('Ticket status not deleted');
      }

      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function deleteTicketStatus() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }

  //Allows you to view the status of a ticket which is searched by its id.
  Future<TicketStatus> _ticketStatus({
    required String ticketId,
    bool scanning = false,
  }) async {
    await getParkingLotData();
    final getTicketStatusURL =
        '$_baseURL/${_dio.options.headers['X-Supercash-Store-Id']}/tickets/$ticketId${scanning ? '?scanning=true' : ''}';

    _logger.d('Obtaining ticket status');

    final transactionId = Utils.generateId();
    final headers = {'X-Supercash-Tid': transactionId};

    Response<dynamic>? response;
    try {
      response = await _dio.get(
        getTicketStatusURL,
        options: Options(contentType: 'application/json', headers: headers),
      );

      response.data['status']['state'] = response.data['state'];
      response.data['status']['gracePeriodMaxTime'] =
          response.data['gracePeriodMaxTime'];
      _logger.d(
        'Ticket status obtained: ${response.data['status']}',
      );
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: ticketStatus() on parking_lot_repository",
          );
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: ticketStatus() on parking_lot_repository",
          );
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: ticketStatus()`
          _logger.e(
            'Critical server error: ${e.message} in the function: ticketStatus() on parking_lot_repository',
          );
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: ticketStatus() on parking_lot_repository',
          );
        }
      }
      throw Exception();
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function ticketStatus() on parking_lot_repository',
      );
      throw Exception();
    }
    return TicketStatusSerializer.fromJson(
      response.data['status'] as Map<String, dynamic>,
    ).toDomain();
  }

  @override
  Future<Either<TicketFailure, TicketStatus>> fetchTicketStatus({
    required String ticketId,
    bool scanning = false,
  }) async {
    _logger.d('Loading ticket status with fee');
    try {
      final tupleTicketStatusAndFee =
          await waitConcurrently<TicketStatus, double>(
        _ticketStatus(ticketId: ticketId, scanning: scanning),
        _getServiceFee(),
      );
      TicketStatus status = tupleTicketStatusAndFee.value1;
      status = status.copyWith(fee: tupleTicketStatusAndFee.value2);
      _logger.d('Ticket status with fee loaded: $status');
      return right(status);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: fetchTicketStatus() on parking_lot_repository",
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: fetchTicketStatus() on parking_lot_repository",
          );
          return left(TicketFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          // TODO: resolve exceptions properly from the backend and replace `function: getUsersTickets()`
          _logger.e(
            'Critical server error: ${e.message} in the function: fetchTicketStatus() on parking_lot_repository',
          );
          return left(TicketFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: fetchTicketStatus() on parking_lot_repository',
          );
          return left(TicketFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function fetchTicketStatus() on parking_lot_repository',
      );
      return left(TicketFailure.unexpected());
    }
  }
}
