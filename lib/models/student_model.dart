class StudentModel {
  int id;
  int? teacherId;
  String? name;
  String? headName;

  StudentModel({required this.id, this.teacherId, this.name, this.headName});

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
      id: json['id'],
      teacherId: json['teacherId'],
      name: json['name'],
      headName: json['headName']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['teacherId'] = teacherId;
    data['name'] = name;
    data['headName'] = headName;
    return data;
  }
}
