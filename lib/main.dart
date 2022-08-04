import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyTest1Page(title: 'test1'),
    );
  }
}

class MyTest1Page extends StatefulWidget {
  final String title;
  static const String imageUrl =
      'https://lmg.jj20.com/up/allimg/1114/102920105033/201029105033-6-1200.jpg';

  const MyTest1Page({Key? key, required this.title}) : super(key: key);

  @override
  MyTest1PageState createState() {
    return MyTest1PageState();
  }
}

enum ScrollState { scrolling, scrollEnd }

class MyTest1PageState extends State<MyTest1Page>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double appBarHeight = 0;
  bool hideLeading = false;
  final double minMargin = 20;
  final double maxMargin = 40;
  final double maxExtent = 180.0;
  late Animation<double> animation;
  late AnimationController animationController;
  ScrollState scrollState = ScrollState.scrollEnd;
  double startBtnTranslationX = 0.0;
  double endBtnTranslationX = 50.0;
  bool btnIsHide = false;
  bool canTranslation = false;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween(begin: startBtnTranslationX, end: endBtnTranslationX)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn));
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        NotificationListener(
          onNotification: (onNotification) {
            if (onNotification is ScrollUpdateNotification ||
                onNotification is ScrollStartNotification) {
              scrollState = ScrollState.scrolling;
              canTranslation = false;
              if (btnIsHide == false) {
                debugPrint('当前滑动状态 $scrollState');
                btnIsHide = true;
                setState(() {
                  animationController.forward();
                });
              }
            } else if (onNotification is ScrollEndNotification) {
              scrollState = ScrollState.scrollEnd;
              canTranslation = true;
              if (btnIsHide == true) {
                btnIsHide = false;
                debugPrint('当前滑动状态 $scrollState');
                Future.delayed(const Duration(seconds: 2))
                    .then((value) => setState(() {
                          if (canTranslation) animationController.reverse();
                        }));
              }
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child:
                      hideLeading ? const Icon(Icons.arrow_back_ios_new) : null,
                ),
                //leading: hideLeading ? const Icon(Icons.arrow_back_ios_new) : null,
                expandedHeight: maxExtent,
                flexibleSpace: buildFlexibleSpace(),
              ),
              SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                            title: Text('child$index'),
                          ),
                      childCount: 20),
                  itemExtent: 100),
            ],
          ),
        ),
        buildFloatBtn1(),
      ],
    ));
  }

  Widget buildFlexibleSpace() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        //获取状态栏的高度 并用appbar的高度-状态栏的高度=appbar的真实高度
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        appBarHeight = boxConstraints.biggest.height - statusBarHeight;
        final double t =
            (appBarHeight - kToolbarHeight) / (maxExtent - kToolbarHeight);
        final double detFactor = 1 - t;
        final double leftRightMargin =
            minMargin + (maxMargin - minMargin) * detFactor;
        return FlexibleSpaceBar(
          expandedTitleScale: 1.0,
          collapseMode: CollapseMode.pin,
          centerTitle: true,
          background: CachedNetworkImage(
            imageUrl: MyTest1Page.imageUrl,
            fit: BoxFit.fill,
            height: double.infinity,
          ),
          title: Padding(
            padding:
                EdgeInsets.only(left: leftRightMargin, right: leftRightMargin),
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: const Text('data'),
            ),
          ),
        );
      },
    );
  }

  Widget buildFloatBtn1() {
    return Positioned(
      right: 10,
      bottom: 60,
      child: Transform(
        transform: Matrix4.translationValues(animation.value, 0, 0),
        child: const ClipOval(
          child: Icon(
            Icons.add_circle,
            size: 50,
          ),
        ),
      ),
    );
  }
}
