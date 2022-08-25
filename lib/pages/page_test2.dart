import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PageTest2 extends StatefulWidget {
  const PageTest2({Key? key}) : super(key: key);

  @override
  PageTest2State createState() {
    return PageTest2State();
  }
}

class PageTest2State extends State<PageTest2> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageTest2Model(),
      builder: (context, child) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0.0,
                  pinned: true,
                  title: Text(
                    'PageTest',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  flexibleSpace: Container(
                    color: Colors.red,
                  ),
                  centerTitle: true,
                  expandedHeight: 200.w,
                ),
                SliverPersistentHeader(
                  delegate: CustomSliverPersistentHeaderDelegate(
                      child: Container(
                    color: Colors.green,
                    constraints:
                        BoxConstraints(maxHeight: 200.w, minHeight: 100.w),
                  )),
                  pinned: true,
                ) ,
              ];
            },
            body: ListView.separated(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('item$index'),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0.8.w,
                  color: Colors.grey,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PageTest2Model extends ChangeNotifier {}

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Container child;

  CustomSliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.constraints!.maxHeight;

  @override
  double get minExtent => child.constraints!.minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
