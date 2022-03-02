import 'package:absq/model/base_model.dart';
import 'package:absq/vo/registration.dart';

import '../constants.dart';

class RegistrationModel extends BaseModel {
  List<Registration> registerations = [
    Registration(
        name: "Kaung Htet",
        centerName: "ABSQ",
        centerNumber: "MM025",
        date: DateTime.now(),
        dateOfBirth: DateTime(2017, 2, 15),
        gender: "male",
        idNumber: "R20220201001",
        address: "Hlaing Township,Yangon",
        email: "kaunghtet@gmail.com",
        phone: "959 970987640",
        schoolNameAndTeacher: "YLF",
        formType: cefl_type,
        level: 'A2 Flyers'),
    Registration(
        name: "Hsu Myat",
        centerName: "ABSQ",
        centerNumber: "MM026",
        date: DateTime.now(),
        dateOfBirth: DateTime(2018, 2, 15),
        gender: "female",
        idNumber: "R20220201002",
        address: "Tarmwe Township,Yangon",
        email: "sumyat@gmail.com",
        phone: "959 970987640",
        schoolNameAndTeacher: "YLF",
        formType: cefl_type,
        level: 'A2 Flyers'),
    Registration(
        name: "Kaung Kaung",
        centerName: "ABSQ",
        centerNumber: "MM027",
        date: DateTime.now(),
        dateOfBirth: DateTime(2018, 2, 15),
        gender: "female",
        idNumber: "R20220201002",
        address: "Tarmwe Township,Yangon",
        email: "sumyat@gmail.com",
        phone: "959 970987640",
        schoolNameAndTeacher: "YLF",
        formType: cefl_type,
        level: 'A2 Flyers')
  ];
}
