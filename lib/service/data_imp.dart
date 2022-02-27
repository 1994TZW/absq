import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:absq/data/data_provider.dart';

import 'data_service.dart';

class DataServiceImp implements DataService {
  DataServiceImp({
    this.connectivity,
    required this.dataProvider,
  });

  final Connectivity? connectivity;
  final DataProvider dataProvider;

  @override
  Future<void> create(dynamic payload, String path) {
    return dataProvider.create(payload, path);
  }

  @override
  Future<void> update(dynamic payload, String path) {
    return dataProvider.update(payload, path);
  }

  @override
  Future<void> delete(dynamic payload, String path) {
    return dataProvider.delete(payload, path);
  }

  @override
  Future<void> start(dynamic payload, String path) {
    return dataProvider.start(payload, path);
  }

  @override
  Future<void> end(dynamic payload, String path) {
    return dataProvider.end(payload, path);
  }

  @override
  Future<void> close(dynamic payload, String path) {
    return dataProvider.close(payload, path);
  }

  @override
  Future<void> acknowledge(payload, String path) {
    return dataProvider.acknowledge(payload, path);
  }

  @override
  Future<void> cancel(dynamic payload, String path) {
    return dataProvider.close(payload, path);
  }
}
