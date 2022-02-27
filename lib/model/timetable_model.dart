import 'package:absq/model/base_model.dart';
import 'package:absq/vo/timetable.dart';

class TimetableModel extends BaseModel {

  List<TimeTable> timeTables = [
    TimeTable(desc: "Available Cambridge Exams", url: "assets/t2.jpg"),
    TimeTable(desc: "Teaching Knowledget Test(TKT)", url: "assets/t1.jpg"),
    TimeTable(desc: "Available Cambridge Exams", url: "assets/t2.jpg"),
    TimeTable(desc: "Teaching Knowledget Test(TKT)", url: "assets/t1.jpg"),
  ];
}
