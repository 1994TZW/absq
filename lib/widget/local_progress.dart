import 'package:flutter/material.dart';
import 'package:progress/progress.dart';
import 'package:absq/helper/theme.dart';

class LocalProgress extends Progress {
  LocalProgress({Key? key, required bool inAsyncCall, required Widget child})
      : super(
            key: key,
            inAsyncCall: inAsyncCall,
            child: child,
            opacity: 0.6,
            progressIndicator: Center(
              child: SizedBox(
                height: 100,
                width: 300,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Loading...")
                    ],
                  ),
                ),
              ),
            ));

  @override
  Widget build(BuildContext context) {
    if (inAsyncCall) {
      // hide keyboard
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    return super.build(context);
  }
}
