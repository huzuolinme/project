import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytest/pages/page_test4.dart';
import 'package:mytest/util/stream_controls.dart';
import 'package:provider/provider.dart';

class PageTest3 extends StatefulWidget {
  const PageTest3({Key? key}) : super(key: key);

  @override
  PageTest3State createState() {
    return PageTest3State();
  }
}

class PageTest3State extends State<PageTest3> {
  late StreamController<dynamic> streamController;

  @override
  void initState() {
    streamController = StreamControls().register('PageTest3State');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageTest3Model>(
      create: (_) {
        return PageTest3Model();
      },
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('PageTest3'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PageTest4();
                      },
                    ),
                  );
                },
                child: const Text('click'),
              ),
              StreamBuilder(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text('data is ${snapshot.data}'),
                    );
                  }
                  return const Center(
                    child: Text('error'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    StreamControls().unRegister('PageTest3State', streamController);
    super.dispose();
  }
}

class PageTest3Model extends ChangeNotifier {
  void change() {}
}
