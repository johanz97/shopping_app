abstract class ITicketIdRepository {
  Future<bool> saveTicketId(String ticketId);
  Future<String> getTicketId();
  Future<void> removeTicketId();
}
