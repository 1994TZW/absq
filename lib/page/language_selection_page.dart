import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/transalation.dart';
import 'package:absq/helper/shared_pref.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

class InitialLanguageSelectionPage extends StatefulWidget {
  const InitialLanguageSelectionPage({Key? key}) : super(key: key);

  @override
  _InitialLanguageSelectionPageState createState() =>
      _InitialLanguageSelectionPageState();
}

class _InitialLanguageSelectionPageState
    extends State<InitialLanguageSelectionPage> {
  static final List<String> languagesList = Translation().supportedLanguages;
  static final List<String> languageCodesList =
      Translation().supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  late String selectedLanguage;
  late int selectedIndex;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    var languageModel = Provider.of<LanguageModel>(context, listen: false);
    // this.selectedIndex = languageModel.isEng ? 0 : 1;
    selectedIndex = 1;
    loadLaunguage(languageModel);
  }

  loadLaunguage(LanguageModel languageModel) async {
    var lan = await languageModel.load();
    if (selectedLanguage != lan) {
      setState(() {
        selectedLanguage = lan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor],
              begin: FractionalOffset(0.8, 0.9),
              end: FractionalOffset(0.9, 0.0),
              stops: [0.0, 1.0],
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: LocalText(context, "language.selection.title",
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 0),
                    child: Card(
                      color: const Color(0xfff4edec),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: 300,
                        height: 160,
                        child: Column(
                            children: languagesList.asMap().entries.map((e) {
                          var language = e.value;
                          var key = e.key;
                          return InkWell(
                            onTap: () {
                              _select(key, language);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: key == languagesList.length - 1
                                  ? const BoxDecoration()
                                  : BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                              child: ListTile(
                                  leading: language == 'English'
                                      ? const CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                            "icons/flags/png/gb.png",
                                            package: 'country_icons',
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                            "icons/flags/png/mm.png",
                                            package: 'country_icons',
                                          ),
                                        ),
                                  title: Text(language),
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.grey[400],
                                    ),
                                    child: Radio(
                                      value: key,
                                      groupValue: selectedIndex,
                                      onChanged: (int? i) =>
                                          _select(key, language),
                                      activeColor: primaryColor,
                                    ),
                                  )),
                            ),
                          );
                        }).toList()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.only(left: 230, top: 20),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          _next();
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Center(
                              child: Icon(Icons.arrow_forward,
                                  color: Colors.black87)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _select(int index, String lang) {
    setState(() {
      selectedIndex = index;
      selectedLanguage = lang;
      Translation().onLocaleChanged!(Locale(languagesMap[lang]));
      Provider.of<LanguageModel>(context, listen: false)
          .saveLanguage(selectedLanguage);
    });
  }

  _next() {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPref.finishFirstLaunch();
      // String page = isLogin ? "/home" : "/login";
      String page = "/login";
      Navigator.of(context).pushReplacementNamed(page);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
