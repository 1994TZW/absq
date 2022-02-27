import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:absq/config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'api_helper.dart';

class NetworkConnectivity {
  final log = Logger('NetworkConnectivity');

  static final NetworkConnectivity instance = NetworkConnectivity._internal();
  static String hostName = "";
  NetworkConnectivity._internal() {
    _initialise();
    var uri = Uri.parse(Config.instance.apiURL);
    hostName = uri.host;
    log.info("host name:$hostName");
  }

  Connectivity connectivity = Connectivity();

  final StreamController _controller = StreamController.broadcast();

  Stream get statusStream => _controller.stream;

  void _initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    // lookup if connectivity is not none
    if (result != ConnectivityResult.none) {
      try {
        final hostNameLookup = await InternetAddress.lookup(hostName);
        if (hostNameLookup.isNotEmpty &&
            hostNameLookup[0].rawAddress.isNotEmpty) {
          if (await checkHeartbeat()) {
            isOnline = true;
          }
        } else {
          isOnline = false;
        }
      } on SocketException catch (_) {
        isOnline = false;
      }
    }

    if (!_controller.isClosed) _controller.sink.add({"isOnline": isOnline});
  }

  Future<bool> checkHeartbeat() async {
    var result = await requestAPI("/hb", "GET");
    var status = result["status"];
    if (status != null && status != "") {
      return true;
    }
    return false;
  }

  void disposeStream() => _controller.close();
}
