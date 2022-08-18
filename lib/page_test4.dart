import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytest/util/stream_controls.dart';
import 'package:provider/provider.dart';

class PageTest4 extends StatefulWidget {
  const PageTest4({Key? key}) : super(key: key);

  @override
  PageTest4State createState() {
    return PageTest4State();
  }
}

class PageTest4State extends State<PageTest4> {
  @override
  void initState() {
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
                  StreamControls().pushData('PageTest3State', 'push data');
                },
                child: const Text('click'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PageTest3Model extends ChangeNotifier {
  void change() {}
}
