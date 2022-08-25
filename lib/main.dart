import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytest/extension_factory.dart';
import 'package:mytest/pages/page_test.dart';
import 'package:mytest/pages/page_test2.dart';
import 'package:mytest/pages/page_test3.dart';
import 'package:mytest/pages/page_test5.dart';
import 'package:mytest/widget/tag_title_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MainModel>(
          create: (_) => MainModel(),
          builder: (context, child) {
            return const MyApp();
          },
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyTest1Page(title: 'test1'),
        );
      },
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
              if (onNotification is ScrollUpdateNotification) {
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
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 11.w, right: 10.w),
                      child: const Icon(Icons.access_time_filled),
                    )
                  ],
                  actionsIconTheme: const IconThemeData(color: Colors.black),
                  titleSpacing: 0,
                  pinned: true,
                  elevation: 10,
                  // leading: Padding(
                  //   padding: EdgeInsets.only(bottom: 11.w),
                  //   child: const Icon(Icons.arrow_back_ios_new),
                  // ),
                  //leading: hideLeading ? const Icon(Icons.arrow_back_ios_new) : null,
                  expandedHeight: maxExtent,
                  flexibleSpace: buildFlexibleSpace(),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => buildGridItem(),
                    childCount: 5,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        (MediaQuery.of(context).size.width) / 5, //每一个格子占的空间
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20.w,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.grey,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 1, bottom: 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildGridItem2();
                      },
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 66,
                        crossAxisCount: 2,
                        mainAxisSpacing: 0.8,
                        crossAxisSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20.w,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index % 5 == 0) {
                      return buildListInformationItem();
                    }
                    return buildListItem(index);
                  }, childCount: 20),
                ),
              ],
            ),
          ),
          buildFloatBtn1(),
        ],
      ).bgColor(Colors.white),
    );
  }

  Widget buildListInformationItem() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [
          Text(
            '这是一条很长的资讯这是一条很长的资讯这是一条很长的资讯这是一条很长的资讯这是一条很长的资讯',
            style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.w),
          Row(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: MyTest1Page.imageUrl,
                  height: 88.w,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 3.w),
                  child: CachedNetworkImage(
                    imageUrl: MyTest1Page.imageUrl,
                    height: 88.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: MyTest1Page.imageUrl,
                  height: 88.w,
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
          SizedBox(height: 10.w),
        ],
      ),
    );
  }

  Widget buildListItem(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagTitleWidget(
            titleStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                height: 1.2),
            title: '我就是标题',
            tagColor: Colors.red,
            tags: const ['置顶'],
          ),
          SizedBox(height: 8.w),
          Row(
            children: [
              Text(
                '学历：不限',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              Text(
                '经验：不限',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              const Expanded(child: SizedBox()),
              Text(
                '面议',
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          Text(
            '公司名字',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.w),
          TagTitleWidget(
            titleStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                height: 1.2),
            title: '',
            tagColor: Colors.blue,
            tags: const ['牛逼', '厉害'],
          ),
          SizedBox(height: 10.w),
          if (index < 19)
            Divider(
              height: 0.8.w,
              color: Colors.grey,
            ),
          SizedBox(height: 10.w),
        ],
      ),
    );
  }

  Widget buildGridItem2() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'text1',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w200),
              ),
              Text(
                'text2',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w200),
              ),
              Text(
                'text3',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w200),
              )
            ],
          ),
          const Icon(
            Icons.ac_unit,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget buildGridItem() {
    Widget item = Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.ac_unit,
            size: 40,
          ),
          Text('data')
        ],
      ),
    );
    return item;
  }

  ///可展开的控件区域组件
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
        child: ClipOval(
          child: GestureDetector(
            child: const Icon(
              Icons.add_circle,
              size: 50,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const PageTest5();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainModel extends ChangeNotifier {}
