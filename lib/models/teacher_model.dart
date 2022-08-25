import 'package:mytest/models/student_model.dart';

class TeacherModel {
  int? id;
  String? name;
  bool? select;
  List<StudentModel>? studentList;

  TeacherModel({required this.id, this.name, this.select, this.studentList});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    select = json['select'];
    if (json['students'] != null) {
      studentList = [];
      json['students']?.forEach((v) {
        studentList?.add(StudentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['select'] = select;
    return data;
  }
}
