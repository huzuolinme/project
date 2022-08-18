import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'main.dart';

enum LayoutChildId {
  topCenter,
  topLeft,
  topRight,
  center,
  centerLeft,
  centerRight,
  bottomCenter,
  bottomLeft,
  bottomRight
}

class PageTest extends StatefulWidget {
  const PageTest({Key? key}) : super(key: key);

  @override
  PageTestState createState() {
    return PageTestState();
  }
}

class PageTestState extends State<PageTest>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> listData = [
    {"name": "user1", "age": "10"},
    {"name": "user2", "age": "11"},
    {"name": "user3", "age": "12"},
    {"name": "user4", "age": "13"},
    {"name": "user5", "age": "14"}
  ];

  bool _sortAscending = false;
  var _dragData;
  late Animation<Decoration> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = DecorationTween(
      begin: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      end: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
    ).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    return ChangeNotifierProvider<TestModel>(
      create: (_) {
        return TestModel();
      },
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'PageTest',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: CachedNetworkImage(
                  imageUrl: MyTest1Page.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: ModalBarrier(
                  color: Colors.black.withOpacity(0.4),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildExpandList(BuildContext context) {
    return Consumer<TestModel>(
      builder: (context, testModel, child) {
        return ExpansionPanelList(
          children: testModel.listBool.map((isExpanded) {
            return ExpansionPanel(
              isExpanded: isExpanded,
              headerBuilder: (context, isExpand) {
                return const ListTile(
                  title: Text('data'),
                );
              },
              body: Container(
                height: 200,
                color: Colors.red,
              ),
            );
          }).toList(),
          expansionCallback: (index, isExpand) {
            testModel.updateChildItem(index, isExpand);
          },
        );
      },
    );
  }

  List<DataRow> getRows() {
    List<DataRow> listWidgets = [];
    listData
        .map((map) => {
              listWidgets.add(
                DataRow(
                  cells: [
                    DataCell(
                      Text('${map["name"]}'),
                    ),
                    DataCell(
                      Text('${map["age"]}'),
                    ),
                  ],
                ),
              )
            })
        .toList();
    return listWidgets;
  }
}

class CustomDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    if (hasChild(LayoutChildId.topLeft)) {
      Size topLeft =
          layoutChild(LayoutChildId.topLeft, BoxConstraints.loose(size));
      positionChild(LayoutChildId.topLeft, Offset.zero);
    }
    if (hasChild(LayoutChildId.topCenter)) {
      Size topCenterSize =
          layoutChild(LayoutChildId.topCenter, BoxConstraints.loose(size));
      positionChild(LayoutChildId.topCenter,
          Offset(size.width / 2 - topCenterSize.width / 2, 0));
    }
    if (hasChild(LayoutChildId.topRight)) {
      Size topRightSize =
          layoutChild(LayoutChildId.topRight, BoxConstraints.loose(size));
      positionChild(
          LayoutChildId.topRight, Offset(size.width - topRightSize.width, 0));
    }
    if (hasChild(LayoutChildId.centerLeft)) {
      Size centerLeftSize =
          layoutChild(LayoutChildId.centerLeft, BoxConstraints.loose(size));
      positionChild(LayoutChildId.centerLeft,
          Offset(0, size.height / 2 - centerLeftSize.height / 2));
    }
    if (hasChild(LayoutChildId.center)) {
      Size centerSize =
          layoutChild(LayoutChildId.center, BoxConstraints.loose(size));
      positionChild(
          LayoutChildId.center,
          Offset(size.width / 2 - centerSize.width / 2,
              size.height / 2 - centerSize.height / 2));
    }
    if (hasChild(LayoutChildId.centerRight)) {
      Size centerRightSize =
          layoutChild(LayoutChildId.centerRight, BoxConstraints.loose(size));
      positionChild(
          LayoutChildId.centerRight,
          Offset(size.width - centerRightSize.width,
              size.height / 2 - centerRightSize.height / 2));
    }
    if (hasChild(LayoutChildId.bottomLeft)) {
      Size bottomLeftSize =
          layoutChild(LayoutChildId.bottomLeft, BoxConstraints.loose(size));
      positionChild(LayoutChildId.bottomLeft,
          Offset(0, size.height - bottomLeftSize.height));
    }
    if (hasChild(LayoutChildId.bottomCenter)) {
      Size bottomCenterSize =
          layoutChild(LayoutChildId.bottomCenter, BoxConstraints.loose(size));
      positionChild(
          LayoutChildId.bottomCenter,
          Offset(size.width / 2 - bottomCenterSize.width / 2,
              size.height - bottomCenterSize.height));
    }
    if (hasChild(LayoutChildId.bottomRight)) {
      Size bottomRightSize =
          layoutChild(LayoutChildId.bottomRight, BoxConstraints.loose(size));
      positionChild(
          LayoutChildId.bottomRight,
          Offset(size.width - bottomRightSize.width,
              size.height - bottomRightSize.height));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class TestModel extends ChangeNotifier {
  List<bool> listBool = List.generate(20, (index) => false).toList();

  void updateChildItem(int index, bool isExpand) {
    listBool[index] = !isExpand;
    notifyListeners();
  }
}
// body: SingleChildScrollView(
// child: buildExpandList(context),
// ),
// body: Center(
//   child: CustomMultiChildLayout(
//     delegate: CustomDelegate(),
//     children: [
//       LayoutId(id: LayoutChildId.topLeft, child: const Text('左上')),
//       LayoutId(id: LayoutChildId.topCenter, child: const Text('中上')),
//       LayoutId(id: LayoutChildId.topRight, child: const Text('左右')),
//       LayoutId(id: LayoutChildId.centerLeft, child: const Text('中左')),
//       LayoutId(id: LayoutChildId.center, child: const Text('中')),
//       LayoutId(id: LayoutChildId.centerRight, child: const Text('中右')),
//       LayoutId(id: LayoutChildId.bottomLeft, child: const Text('左下')),
//       LayoutId(id: LayoutChildId.bottomCenter, child: const Text('中下')),
//       LayoutId(id: LayoutChildId.bottomRight, child: const Text('右下'))
//     ],
//   ),
// ),
// body: DataTable(
//   sortColumnIndex: 1,
//   sortAscending: _sortAscending,//是否升序
//   columns: [
//     const DataColumn(
//       label: Text('姓名'),
//     ),
//     DataColumn(
//         label: const Text('年龄'),
//         numeric: true,
//         onSort: (columnIndex, ascending) {
//           setState(() {
//             _sortAscending = ascending;
//             if (ascending) {
//               listData.sort((a, b) {
//                 return a['age'].toString().compareTo(b['age'].toString());
//               });
//             } else {
//               listData.sort((a, b) {
//                 return b['age'].toString().compareTo(a['age'].toString());
//               });
//             }
//           });
//         }),
//   ],
//   rows: getRows(),
// ),
// body: Column(
//   children: [
//     Draggable(
//       feedback: Container(
//         color: Colors.red,
//         width: 100.w,
//         height: 100.w,
//       ),
//       child: Container(
//         color: Colors.blue,
//         width: 100.w,
//         height: 100.w,
//       ),
//     ),
//     DragTarget<Color>(
//       builder: (context, candidateData, rejectedData) {
//         return _dragData == null
//             ? Container(
//                 width: 100.w,
//                 height: 100.w,
//                 color: Colors.yellow,
//               )
//             : Container(
//                 width: 100.w,
//                 height: 100.w,
//                 color: Colors.green,
//               );
//       },
//       onWillAccept: (color) {
//         return true;
//       },
//       onAccept: (color) {
//         setState(() {
//           _dragData = color;
//         });
//       },
//     ),
//   ],
// )
