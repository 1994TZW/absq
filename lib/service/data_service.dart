abstract class DataService {
  Future<void> create(dynamic payload, String path);
  Future<void> update(dynamic payload, String path);
  Future<void> delete(dynamic payload, String path);
  Future<void> acknowledge(dynamic payload, String path);
  Future<void> start(dynamic payload, String path);
  Future<void> end(dynamic payload, String path);
  Future<void> close(dynamic payload, String path);
  Future<void> cancel(dynamic payload, String path);
}
