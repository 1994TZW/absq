import 'package:logging/logging.dart';
import 'package:absq/helper/api_helper.dart';
import 'package:absq/helper/firebase_helper.dart';

class DataProvider {
  final log = Logger('DataProvider');

  Future<void> create(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }

  Future<void> update(dynamic payload, String path) async {
    return await requestAPI(path, "PUT",
        payload: payload, token: await getToken());
  }

  Future<void> delete(dynamic payload, String path) async {
    return await requestAPI(path, "DELETE",
        payload: payload, token: await getToken());
  }

  Future<void> start(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }

  Future<void> end(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }

  Future<void> close(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }

  Future<void> acknowledge(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }

  Future<void> cancel(dynamic payload, String path) async {
    return await requestAPI(path, "POST",
        payload: payload, token: await getToken());
  }
}
