import 'package:absq/model/main_model.dart';
import 'package:absq/vo/user.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'announcement/announcement_list.dart';
import 'exam_timetable/timetable_list.dart';
import 'registration/welcome_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  static const List<Widget> _tabPages = <Widget>[
    WelcomePage(),
    TimeTabelList(),
    AnnouncementList(),
    // Center(child: Text("Students"))
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(AntDesign.form),
      label: 'Registration',
    ),
    const BottomNavigationBarItem(
      icon: Icon(MaterialCommunityIcons.calendar_clock),
      label: 'Exam Timetables',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Ionicons.information_circle_outline),
      label: 'Knowledge Garden',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabPages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: kGrayColor,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: items,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
