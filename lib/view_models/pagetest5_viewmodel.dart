import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mytest/models/student_model.dart';
import 'package:mytest/widget/state_viewmodel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/teacher_model.dart';

class PageTest5ViewModel extends StateViewModel {
  List<TeacherModel> teacherModelList = [];
  List<StudentModel> studentModelList = [];
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();
  String? currentHeadName;
  bool currentHeadVisible = false;

  PageTest5ViewModel.create();

  loadList() {
    for (int i = 0; i < 10; i++) {
      TeacherModel teacherModel =
          TeacherModel(id: i, name: '教师$i', select: false);
      List<StudentModel> studentModelList = [];
      for (int j = 0; j < 10; j++) {
        StudentModel studentModel = StudentModel(
            id: j,
            teacherId: i,
            name: '学生$i$j',
            headName: j == 0 ? teacherModel.name : '');
        studentModelList.add(studentModel);
        this.studentModelList.add(studentModel);
      }
      teacherModel.studentList = studentModelList;
      teacherModelList.add(teacherModel);
    }
    setIdle();

    itemPositionsListener.itemPositions.addListener(() {
      var positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        int min = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;
        selectItem(min);
      }
    });
  }

  void selectItem(int index) {
    for (var e in teacherModelList) {
      e.select = false;
    }
    teacherModelList[index].select = true;
    notifyListeners();
  }

  void scrollToPosition(int teacherIndex) {
    itemScrollController.scrollTo(
        index: teacherIndex, duration: const Duration(milliseconds: 300));
    notifyListeners();
  }
}
