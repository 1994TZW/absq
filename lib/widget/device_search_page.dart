import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/page/util.dart';

import 'barcode_scanner.dart';
import 'local_progress.dart';

class DeviceSearchPage extends StatefulWidget {
  @override
  _DeviceSearchPageState createState() => _DeviceSearchPageState();
}

class _DeviceSearchPageState extends State<DeviceSearchPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: primaryColor,
          title: Text(
            'Search',
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Search by qrcode: '),
                InkWell(
                  onTap: () async {
                    await _scan();
                  },
                  child: ImageIcon(
                    AssetImage(
                      "assets/icons/qrcode.png",
                    ),
                    color: primaryColor,
                    size: 40,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _scan() async {
    try {
      String? barcode = await scanBarcode();
      if (barcode != null) {
        setState(() {
          // _transcationIDCtl.text = barcode;
        });
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
