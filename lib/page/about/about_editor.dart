import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/about.dart';
import 'package:absq/vo/term.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';
import 'package:zefyrka/zefyrka.dart';

import '../util.dart';

class AboutEdit extends StatefulWidget {
  final About about;
  const AboutEdit({Key? key, required this.about}) : super(key: key);
  @override
  _AboutEditState createState() => _AboutEditState();
}

class _AboutEditState extends State<AboutEdit> {
  late ZefyrController _controllerEng;
  late ZefyrController _controllerMm;

  late FocusNode _focusNodeEng;
  late FocusNode _focusNodeMm;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    _controllerEng =
        ZefyrController(_loadDocument(widget.about.aboutEng ?? ""));
    _controllerMm = ZefyrController(_loadDocument(widget.about.aboutMm ?? ""));
    _focusNodeEng = FocusNode();
    _focusNodeMm = FocusNode();
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument(String data) {
    late NotusDocument doc;
    try {
      doc = NotusDocument.fromJson(jsonDecode(data));
    } catch (e) {
      doc = NotusDocument();
    }
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    final savebtn = LocalButton(
      onTap: _save,
      text: 'btn.save',
    );

    return DefaultTabController(
      length: 2,
      child: LocalProgress(
        inAsyncCall: _isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: LocalLargeTitle(
              context,
              "about.title",
              color: primaryColor,
            ),
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.back,
                color: primaryColor,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: _unfocus,
                  icon: const Icon(Icons.check, color: primaryColor))
            ],
            bottom: TabBar(
              onTap: (index) {
                if (index == 0) {
                  _focusNodeEng = FocusNode();
                  FocusScope.of(context).requestFocus(_focusNodeEng);
                } else {
                  _focusNodeMm = FocusNode();
                  FocusScope.of(context).requestFocus(_focusNodeMm);
                }
              },
              tabs: [
                Tab(
                    icon: Image.asset(
                  'icons/flags/png/us.png',
                  package: 'country_icons',
                  fit: BoxFit.fitWidth,
                  width: 25,
                )),
                Tab(
                    icon: Image.asset(
                  'icons/flags/png/mm.png',
                  package: 'country_icons',
                  fit: BoxFit.fitWidth,
                  width: 25,
                )),
              ],
            ),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: TabBarView(
                  children: [
                    textEditor(_controllerEng, _focusNodeEng),
                    textEditor(_controllerMm, _focusNodeMm),
                  ],
                ),
              ),
              savebtn,
            ],
          ),
        ),
      ),
    );
  }

  Widget textEditor(ZefyrController controller, FocusNode focusNode) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: ZefyrEditor(
            autofocus: false,
            padding: const EdgeInsets.all(16),
            controller: controller,
            focusNode: focusNode,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  _unfocus() {
    FocusScope.of(context).unfocus();
  }

  _save() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final contentsEng = jsonEncode(_controllerEng.document);
      final contentsMm = jsonEncode(_controllerMm.document);
      await context
          .read<MainModel>()
          .saveAbout(About(aboutEng: contentsEng, aboutMm: contentsMm));
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      _isLoading = false;
      Navigator.pop(context);
    }
  }
}
