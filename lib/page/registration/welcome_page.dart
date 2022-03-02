import 'package:absq/helper/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../widget/absq_local_app_bar.dart';
import '../login/signin_email.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AbsqLocalAppBar(
          backgroundColor: Colors.white24,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const SigninEmail()),
                  );
                },
                icon: const Icon(
                  FontAwesome.sign_in,
                  color: primaryColor,
                  size: 30,
                )),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Let's Open Our Doors Gloabally",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        // height: 40,
                        filterQuality: FilterQuality.medium,
                      ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height / 4,
                      //   decoration: const BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage('assets/logo.png'))),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {},
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "CEFR",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {},
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "BMAT",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {},
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "Prep Center",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
