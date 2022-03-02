import 'package:absq/model/base_model.dart';
import 'package:absq/vo/timetable.dart';

class TimetableModel extends BaseModel {

  List<TimeTable> timeTables = [
    TimeTable(desc: "TKT exams", url: "assets/t1.jpg"),
    TimeTable(desc: "FCE for school,CAE exams", url: "assets/t2.jpg"),
    TimeTable(desc: "YLE exams", url: "assets/t3.jpg"),
    TimeTable(desc: "KET for school & PET for school", url: "assets/t4.jpg"),
  ];
}
