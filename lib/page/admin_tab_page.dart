import 'package:absq/model/main_model.dart';
import 'package:absq/vo/user.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'announcement/announcement_list.dart';
import 'exam_timetable/timetable_list.dart';
import 'registration/registration_list.dart';
import 'registration/welcome_page.dart';

class AdminTabPage extends StatefulWidget {
  const AdminTabPage({Key? key}) : super(key: key);

  @override
  _AdminTabPageState createState() => _AdminTabPageState();
}

class _AdminTabPageState extends State<AdminTabPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  static const List<Widget> _adminPages = <Widget>[
    RegistrationList(),
    TimeTabelList(),
    AnnouncementList(),
  ];

  List<BottomNavigationBarItem> adminItems = [
    const BottomNavigationBarItem(
      icon: Icon(AntDesign.form),
      label: 'Registrations',
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
      body: _adminPages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: kGrayColor,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: adminItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
