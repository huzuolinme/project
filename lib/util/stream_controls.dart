import 'dart:async';
import 'dart:io';

class StreamControls {
  final Map<String, List<StreamController<dynamic>>> streamMap = {};

  //唯一实例
  factory StreamControls() {
    return _getInstance();
  }

  static StreamControls? _streamControls;

  //构造方法
  StreamControls._internal();

  //实现构造方法
  static StreamControls _getInstance() {
    return _streamControls ??= StreamControls._internal();
  }

  StreamController<dynamic> register(String tag) {
    List<StreamController>? list = streamMap[tag];
    list ??= [];
    StreamController<dynamic> streamController = StreamController();
    list.add(streamController);
    return streamController;
  }

  void pushData(String tag, dynamic content) {
    List<StreamController>? list = streamMap[tag];
    if (list != null) {
      for (var element in list) {
        element.add(content);
      }
    }
  }

  void unRegister(String tag, StreamController controller) {
    if (streamMap.containsKey(tag)) {
      List<StreamController>? list = streamMap[tag];
      list?.remove(controller);
      if (list == null) {
        streamMap.remove(tag);
      }
    }
  }
}
