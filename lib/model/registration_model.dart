import 'package:absq/model/base_model.dart';
import 'package:absq/vo/registration.dart';

import '../constants.dart';

class RegistrationModel extends BaseModel {
  List<String> levels = [
    'Pre-AI Starters',
    'A1 Movers',
    'A2 Flyers',
    'A2 Key(KET)',
    'A2 Key for School',
    'B1 Preliminary(PET)',
    'B1 Preliminary for School',
    'B2 First(FCE)',
    'B2 First for School',
    'C1 Advanc(CAE)',
    'C2 Proficiency',
    'BEC Preliminary'
  ];
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
        schoolName: "International High School\nContact Name:Daw Swe Swe",
        formType: cefl_type,
        level: 'Pre-AI Starters'),
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
        schoolName: "Clinical Medicine School ",
        formType: bmat_type),
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
      schoolName: "International High School",
      formType: prep_center_type,
    )
  ];
}
