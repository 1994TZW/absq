import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:absq/config.dart';
import 'package:absq/vo/dev_info.dart';
import 'package:absq/vo/status.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final log = Logger('requestAPI');

// request makes http request
// if token is null
Future<dynamic> requestAPI(
  String path,
  method, {
  dynamic payload,
  String? token,
  String? url,
}) async {
  DevInfo devInfo = await DevInfo.getDevInfo();

  String deviceName = "${devInfo.model}(${devInfo.id})";
  log.info("device:${devInfo.deviceID},deviceName:$deviceName");

  Map<String, dynamic> headers = {};
  if (token != null) {
    headers["Token"] = token;
  }
  headers["Device"] = devInfo.deviceID + ":" + deviceName;

  BaseOptions options = BaseOptions(
    method: method,
    baseUrl: url ?? Config.instance.apiURL,
    connectTimeout: 10000,
    receiveTimeout: 10000,
    headers: headers,
  );
  log.info("token:$token");

  log.info("baseUrl:${options.baseUrl}, path:$path, method:$method");
  log.info("payload:$payload");
  try {
    Dio dio = Dio(options);
    Response response = await dio.request(
      path,
      data: payload,
    );
    var data = Status.fromJson(response.data);
    if (data.status == 'Ok') {
      return response.data["data"];
    } else {
      throw Exception(data.message);
    }
  } catch (e) {
    log.warning("path:$path, api:$e");
    rethrow;
  }
}

// request makes http request
// if token is null
Future<dynamic> requestDownloadAPI(String path, method,
    {dynamic payload,
    String? token,
    String? url,
    required String filePath}) async {
  DevInfo devInfo = await DevInfo.getDevInfo();

  String deviceName = "${devInfo.model}(${devInfo.id})";
  log.info("device:${devInfo.id},deviceName:${devInfo.model}");

  var bytes = utf8.encode(payload);
  var base64Str = base64.encode(bytes);
  String escapePayload = const HtmlEscape().convert(base64Str);

  try {
    String baseUrl = url ?? Config.instance.apiURL;
    log.info("Path:$baseUrl$path");
    HttpClient client = HttpClient();
    var _downloadData = StringBuffer();
    var fileSave = File(filePath);
    var request = await client.getUrl(Uri.parse("$baseUrl$path"));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    if (token != null) {
      request.headers.set("Token", token);
    }
    request.headers.set("Device", deviceName);
    request.headers.set("payload", escapePayload);
    var response = await request.close();
    response.transform(utf8.decoder).listen((d) => _downloadData.write(d),
        onDone: () {
      fileSave.writeAsString(_downloadData.toString());
    });
  } catch (e) {
    log.warning("path:$path, api:$e");
    rethrow;
  }
}

// request makes http request
// if token is null
Future<dynamic> requestDownloadPDFAPI(String path, method,
    {dynamic payload,
    String? token,
    String? url,
    required String filePath}) async {
  DevInfo devInfo = await DevInfo.getDevInfo();

  String deviceName = "${devInfo.model}(${devInfo.id})";
  log.info("device:${devInfo.id},deviceName:${devInfo.model}");

  var bytes = utf8.encode(payload);
  var base64Str = base64.encode(bytes);
  String escapePayload = const HtmlEscape().convert(base64Str);

  try {
    String baseUrl = url ?? Config.instance.apiURL;
    log.info("Path:$baseUrl$path");
    HttpClient client = HttpClient();
    var fileSave = File(filePath);
    var request = await client.getUrl(Uri.parse("$baseUrl$path"));
    if (token != null) {
      request.headers.set("Token", token);
    }
    request.headers.set("Device", deviceName);
    request.headers.set("payload", escapePayload);
    var response = await request.close();
    List<int> _downloadData = [];

    response.listen((d) => _downloadData.addAll(d), onDone: () {
      fileSave.writeAsBytes(_downloadData);
    });
  } catch (e) {
    log.warning("path:$path, api:$e");
    rethrow;
  }
}

// returns list of urls
Future<List<String>> uploadFiles(String path, List<File> files,
    {String? fileName}) async {
  List<Future<String>> fu = [];
  for (File f in files) {
    Future<String> u = uploadStorage(path, f);
    fu.add(u);
  }
  return Future.wait(fu);
}

Future<String> uploadStorage(String path, File file, {String? fileName}) async {
  fileName ??= const Uuid().v4();
  Reference ref = FirebaseStorage.instance.ref().child('$path/$fileName');
  UploadTask uploadTask = ref.putFile(file);
  await uploadTask;
  String downloadUrl = await ref.getDownloadURL();
  return downloadUrl;
}

Future<void> deleteStorageFromUrls(List<String> urls) async {
  List<Future> fu = [];
  for (int i = 0; i < urls.length; i++) {
    Future f = deleteStorageFromUrl(urls[i]);
    fu.add(f);
  }
  await Future.wait(fu);
  return Future.value(null);
}

Future<void> deleteStorageFromUrl(String url) async {
  try {
    Reference ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete();
  } catch (e) {
    log.warning("deleteStorage:$e");
  }
}
