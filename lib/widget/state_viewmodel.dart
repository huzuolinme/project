import 'package:flutter/material.dart';
import 'package:mytest/widget/view_state.dart';

class StateViewModel extends ChangeNotifier {
  ViewState _viewState = ViewState.idle;

  ViewState get viewState => _viewState;

  bool get isBusy => _viewState == ViewState.busy;

  bool get isError => _viewState == ViewState.error;

  bool get isIdle => _viewState == ViewState.idle;

  bool get isEmpty => _viewState == ViewState.empty;

  ViewStateError? _viewStateError;

  ViewStateError? get viewStateError => _viewStateError;

  String? get errorMsg => _viewStateError?.message; // 错误信息

  /// 防止页面销毁后，异步任务才完成，导致报错
  bool _disposed = false;

  void setEmpty() {
    _updateViewState(ViewState.empty);
  }

  setIdle() {
    _updateViewState(ViewState.idle);
  }

  setBusy() {
    _updateViewState(ViewState.busy);
  }

  setError(String msg,
      {ViewStateErrorType errorType = ViewStateErrorType.defaultError}) {
    _viewState = ViewState.error;
    _viewStateError = ViewStateError(errorType, message: msg);
    notifyListeners();
  }

  _updateViewState(ViewState viewState) {
    _viewState = viewState;
    _viewStateError = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
