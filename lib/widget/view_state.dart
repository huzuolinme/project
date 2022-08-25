/// 页面状态类型
enum ViewState {
  idle,
  busy, // 加载中
  error, // 加载失败
  empty, // 无数据
}

enum ViewStateErrorType {
  defaultError, // 请求错误
  networkError, // 网络错误，本地
}

class ViewStateError {
  ViewStateErrorType _errorType;

  ViewStateErrorType get errorType => _errorType;

  String message;

  ViewStateError(ViewStateErrorType errorType, {String? message})
      : _errorType = errorType,
        message = message ?? '未知错误';
}
