import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_ticket_id_repository.dart';

//This repository will take care of getting the ticket id, either by url or by
// userPreferences.
@LazySingleton(as: ITicketIdRepository)
class TicketIdRepository implements ITicketIdRepository {
  @override
  Future<String> getTicketId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ticket_id') ?? "";
  }

  @override
  Future<bool> saveTicketId(String ticketId) async {
    final prefs = await SharedPreferences.getInstance();
    final noteExist = prefs.getString('ticket_id') == null;

    await prefs.setString('ticket_id', ticketId);
    return noteExist;
  }

  @override
  Future<void> removeTicketId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('ticket_id');
  }
}
