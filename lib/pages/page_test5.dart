import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mytest/util/stream_controls.dart';
import 'package:mytest/view_models/pagetest5_viewmodel.dart';
import 'package:mytest/widget/provider_widget.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../main.dart';
import '../models/teacher_model.dart';

class PageTest5 extends StatefulWidget {
  const PageTest5({Key? key}) : super(key: key);

  @override
  PageTest5State createState() {
    return PageTest5State();
  }
}

class PageTest5State extends State<PageTest5>
    with AutomaticKeepAliveClientMixin<PageTest5>, TickerProviderStateMixin {
  int currentIndex = 0;
  late PageController pageController;
  late StreamController<dynamic> streamController;
  late AnimationController animationController;
  late Animation animation;
  final PageTest5ViewModel _pageTest5ViewModel = PageTest5ViewModel.create();

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.accessibility), label: 'bottom1'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.accessible), label: 'bottom2'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.beach_access), label: 'bottom3'),
  ];

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween(begin: 0, end: 100).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
    streamController = StreamControls().register('PageTest5State');
    pageController = PageController(keepPage: true);
    pageController.addListener(() {
      setState(
        () {
          if (pageController.page == 0) {
            currentIndex = 0;
          } else if (pageController.page == 1) {
            currentIndex = 1;
          } else if (pageController.page == 2) {
            currentIndex = 2;
          }
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        actions: [
          const Icon(Icons.add),
          SizedBox(
            width: 5.w,
          )
        ],
        backgroundColor: Colors.yellow,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 20.w),
          height: 40.w,
          padding:
              EdgeInsets.only(left: 15.w, right: 5.w, top: 4.w, bottom: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '欢迎',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                ),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        },
        currentIndex: currentIndex,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {},
        children: [
          buildPageViewItem1(),
          buildPageViewItem2(),
          buildPageViewItem3()
        ],
      ),
    );
  }

  Widget buildPageViewItem1() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.yellow,
                height: 80.w,
                child: GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 35.w,
                        ),
                        Text(
                          '扫一扫',
                          style: TextStyle(fontSize: 12.w),
                        ),
                      ],
                    );
                  },
                  itemCount: 5,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240.w,
                child: GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 35.w,
                        ),
                        Text(
                          '扫一扫',
                          style: TextStyle(fontSize: 12.w),
                        ),
                      ],
                    );
                  },
                  itemCount: 15,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                ),
              ),
            )
          ];
        },
        body: buildStaggeredItem());
  }

  Widget buildPageViewItem2() {
    return ProviderWidget<PageTest5ViewModel>(
        onModelReady: (model) => _pageTest5ViewModel.loadList(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return const Center(
              child: Text('busy'),
            );
          } else if (viewModel.isError) {
            return const Center(
              child: Text('error'),
            );
          } else if (viewModel.isEmpty) {
            return const Center(
              child: Text('empty'),
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100.w,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        viewModel.selectItem(index);
                        viewModel.scrollToPosition(index);
                      },
                      child: ListTile(
                        title: Text(
                          viewModel.teacherModelList[index].name!,
                          style: TextStyle(
                              color: viewModel.teacherModelList[index].select ==
                                      true
                                  ? Colors.green
                                  : Colors.black),
                        ),
                      ),
                    );
                  },
                  itemCount: viewModel.teacherModelList.length,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ScrollablePositionedList.builder(
                      itemCount: viewModel.teacherModelList.length,
                      itemPositionsListener: viewModel.itemPositionsListener,
                      itemScrollController: viewModel.itemScrollController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.fromLTRB(10.w, 12.w, 10.w, 12.w),
                              color: Colors.white,
                              child: Text(
                                viewModel.teacherModelList[index].name!,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 17.sp),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'data',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                },
                                itemCount: 10,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Visibility(
                      visible: viewModel.currentHeadVisible,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(10.w, 12.w, 10.w, 12.w),
                        color: Colors.white,
                        child: Text(
                          viewModel.currentHeadName == null
                              ? ''
                              : viewModel.currentHeadName!,
                          style: TextStyle(color: Colors.red, fontSize: 17.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        model: _pageTest5ViewModel);
  }

  Widget buildPageViewItem3() {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text('child3'),
    );
  }

  Widget buildStaggeredItem() {
    return Container(
        color: const Color(0xfff5f5f5),
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        child: MasonryGridView.count(
          itemCount: 20,
          crossAxisCount: 2,
          mainAxisSpacing: 5.w,
          crossAxisSpacing: 5.w,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            topRight: Radius.circular(4.r)),
                        color: Colors.white,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                      constraints: BoxConstraints(
                          maxHeight: index % 3 == 0 ? 80.w : 120.w),
                    );
                  },
                  imageUrl: MyTest1Page.imageUrl,
                ),
                Container(
                  color: Colors.white,
                  height: 5.w,
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    '单人一小时自拍',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 15.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.r),
                        bottomRight: Radius.circular(4.r)),
                    color: Colors.white,
                  ),
                )
              ],
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    StreamControls().unRegister('PageTest5State', streamController);
    animationController.dispose();
    super.dispose();
  }
}

class PageTest5Model extends ChangeNotifier {}
