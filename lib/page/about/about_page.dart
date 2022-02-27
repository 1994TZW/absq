import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/page/about/about_editor.dart';
import 'package:absq/vo/about.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/widget/local_text.dart';
import 'package:zefyrka/zefyrka.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late FocusNode _focusNode;
  late NotusDocument document = NotusDocument();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  NotusDocument _loadDocument(Setting? setting) {
    bool isEng = Provider.of<LanguageModel>(context).isEng;
    String about = isEng ? (setting!.aboutEng) : (setting!.aboutMm);
    print("setting about:${about}");
    late NotusDocument doc;
    try {
      doc = NotusDocument.fromJson(jsonDecode(about));
    } catch (e) {
      doc = NotusDocument();
    }
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    Setting? setting = Provider.of<MainModel>(context).setting;
    bool isEditable =
        context.select((MainModel m) => m.user?.hasAdmin() ?? false);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: LocalText(
          context,
          'about.title',
          color: primaryColor,
          fontSize: 20,
        ),
        actions: isEditable
            ? [
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).push<void>(CupertinoPageRoute(
                          builder: (context) =>
                              AboutEdit(about: About.fromSetting(setting!)),
                        )),
                    icon: const Icon(
                      Icons.edit,
                      color: primaryColor,
                    ))
              ]
            : [],
      ),
      body: ZefyrEditor(
        padding: const EdgeInsets.all(16),
        controller: ZefyrController(_loadDocument(setting)),
        focusNode: _focusNode,
      ),
    );
  }
}
