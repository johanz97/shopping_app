import 'dart:convert';

import 'package:hive/hive.dart';

import '../app/enviroments/enviroments_serializer.dart';
import '../user/user/user_serializer.dart';

//This class allows us to define the data to be stored in the LocalStorage
class LocalRepository {
  const LocalRepository();
  static void setAllEnviroments(EnviromentsSerializer enviromentsSerializer) {
    final box = Hive.box('app');
    box.put('all_envs', json.encode(enviromentsSerializer.toJson()));
  }

  static EnviromentsSerializer? getEnviroments() {
    final box = Hive.box('app');
    final allEnvsMap = json.decode(box.get('all_envs') as String);
    return EnviromentsSerializer.fromJson(allEnvsMap as Map<String, dynamic>);
  }

  static void setEtag(String etag) {
    final box = Hive.box('app');
    box.put('etag', etag);
  }

  static String? getEtag() {
    final box = Hive.box('app');
    return box.get('etag') as String?;
  }

  static void setToken(String token) {
    final box = Hive.box('app');
    box.put('token', token);
  }

  static String? getToken() {
    final box = Hive.box('app');
    return box.get('token') as String?;
  }

  static void setSuperCashUid(int uid) {
    final box = Hive.box('app');
    box.put('super_cash_uid', uid);
  }

  static int? getSuperCashUid() {
    final box = Hive.box('app');
    return (box.get('super_cash_uid') ?? 1) as int?;
  }

  static void setUserSerializer(UserSerializer userSerializer) {
    final box = Hive.box('userData');
    box.put('userSerializer', json.encode(userSerializer.toJson()));
  }

  static UserSerializer? getUserSerializer() {
    final box = Hive.box('userData');

    return box.get('userSerializer') != null
        ? UserSerializer.fromJson(
            json.decode(box.get('userSerializer') as String)
                as Map<String, dynamic>,
          )
        : null;
  }

  static void deleteUser() {
    Hive.box('userData').clear();
    Hive.box<Map>('credit_cards').clear();
    //Hive.box<Map>('parkingLot').clear();
  }

  static void setIsLogged({required bool isLogged}) {
    final box = Hive.box('userData');
    box.put("isLogged", isLogged);
  }

  static bool isLogged() {
    final box = Hive.box('userData');
    return (box.get("isLogged") ?? false) as bool;
  }

  static void setIndexStepper({required int index}) {
    final box = Hive.box('userData');
    box.put("index_stepper", index);
  }

  static int getIndexStepper() {
    final box = Hive.box('userData');
    return (box.get("index_stepper") ?? 0) as int;
  }

  static void setCreditCardsList({
    required List<Map<String, dynamic>> creditCards,
  }) {
    final box = Hive.box<Map>('credit_cards');
    for (var count = 0; count < creditCards.length; count++) {
      box.put(count.toString(), creditCards[count]);
    }
  }

  static List<Map<String, dynamic>>? getCreditCardsList() {
    final box = Hive.box<Map>('credit_cards');
    box.values.cast<Map<dynamic, dynamic>>();
    final List<Map<String, dynamic>>? result = box.isNotEmpty
        ? box.values.map((e) => Map<String, dynamic>.from(e)).toList()
        : null;
    if (result != null) {
      final Map<String, dynamic> newAddress = <String, dynamic>{};
      for (var cardsKey = 0; cardsKey < result.length; cardsKey++) {
        final address = result[cardsKey]['address'];
        for (final dynamic addressKey in address.keys) {
          newAddress[addressKey.toString()] = address[addressKey];
          if (addressKey.toString() == 'country') {
            final Map<String, dynamic> countries = <String, dynamic>{};
            for (final dynamic countriesKey in newAddress[addressKey].keys) {
              countries[countriesKey.toString()] =
                  newAddress[addressKey][countriesKey];
            }
            newAddress[addressKey.toString()] = countries;
          }
        }
        result[cardsKey]['address'] = newAddress;
      }
    }
    return result;
  }

  static void deleteAllCards() {
    final box = Hive.box<Map>('credit_cards');
    box.clear();
  }

  static void setTicketStatusList({
    required List<String> ticketsMapList,
  }) {
    final box = Hive.box('parkingLot');
    box.clear();
    for (var count = 0; count < ticketsMapList.length; count++) {
      box.put(count.toString(), ticketsMapList[count]);
    }
  }

  static List<String>? getTicketStatusList() {
    final box = Hive.box('parkingLot');
    final List<String>? result =
        box.isNotEmpty ? box.values.map((e) => e.toString()).toList() : null;
    return result;
  }

  static void setIsNewUser({
    required String key,
    required bool isNewUser,
  }) {
    final box = Hive.box('userData');
    box.put(key, isNewUser);
  }

  static bool getIsNewUser(String key) {
    final box = Hive.box('userData');
    return (box.get(key) ?? true) as bool;
  }

  static void setGenres(List<Map<String, dynamic>> genres) {
    final box = Hive.box<Map>('genres');
    for (var count = 0; count < genres.length; count++) {
      box.put(count.toString(), genres[count]);
    }
  }

  static List<Map<String, dynamic>>? getGenres() {
    final box = Hive.box<Map>('genres');
    box.values.cast<Map<dynamic, dynamic>>();
    final List<Map<String, dynamic>>? result = box.isNotEmpty
        ? box.values.map((e) => Map<String, dynamic>.from(e)).toList()
        : null;
    return result;
  }
}
