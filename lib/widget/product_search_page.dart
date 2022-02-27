import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

import 'local_progress.dart';

class ProductSearchPage extends StatefulWidget {
  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
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
      ),
    );
  }
}
