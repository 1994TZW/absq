// import 'package:barcode_scan2/barcode_scan2.dart';

Future<String?> scanBarcode() async {
  try {
    // ScanResult result = await BarcodeScanner.scan();
    // if (result.type == ResultType.Barcode) {
    //   return result.rawContent;
    // } else {
      return null;
    // }
  } catch (e) {
    print('error: $e');
    return null;
  }
}
