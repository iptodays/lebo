import 'dart:async';

import 'package:flutter/services.dart';

class Lebo {
  Lebo._();

  static Lebo get instance => _instance;
  static late final Lebo _instance = Lebo._();

  bool get isAuthorized => _isAuthorized;
  bool _isAuthorized = false;

  static const String _METHOD_ENABLELOG = 'enableLog';
  static const String _METHOD_AUTH = 'auth';
  static const String _METHOD_SETUSERINFO = 'setUserInfo';
  static const String _METHOD_CLEARUSERID = 'clearUserID';
  static const String _METHOD_ENABLELOCALNOTIFICATION =
      'enableLocalNotification';
  static const String _METHOD_ENABLELOGFILESAVE = 'enableLogFileSave';

  late final MethodChannel _channel = const MethodChannel('com.iptoday.lebo')
    ..setMethodCallHandler(_setMethodCallHandler);

  /// 由原生调用flutter的处理
  Future<dynamic> _setMethodCallHandler(MethodCall call) async {
    switch (call.method) {
      default:
    }
  }

  /// 是否打开log，打印输出在控制台
  /// * [enable] true代表打开，false代表关闭，默认为false
  Future<void> enableLog({required bool enable}) async {
    _channel.invokeMethod(_METHOD_ENABLELOG, {'enable': enable});
  }

  /// 授权认证接口。
  ///
  /// 注意：请在调试阶段确保SDK能正确的授权成功，
  /// 否则，当连续出现100次授权请求失败，且没有任何一次授权成功过，则SDK功能搜索功能不再可用。
  /// * [appId] 乐播开发者平台中注册的appID
  /// * [secretKey] 乐播开发者平台中注册的密钥
  Future<bool> auth({
    required String appId,
    required String secretKey,
    void Function(int? code, String? message)? error,
  }) async {
    if (_isAuthorized) {
      return _isAuthorized;
    }
    var result = await _channel.invokeMethod(
      _METHOD_AUTH,
      {
        'appId': appId,
        'secretKey': secretKey,
      },
    );
    if (error != null) {
      error(
        result['code'],
        result['message'],
      );
    }
    _isAuthorized = result['result'];
    return _isAuthorized;
  }

  /// 设置用户唯一标识，用于云端存取用户的远程设备信息
  /// 非必要的设置，不设置，则不进行云端存取，仅本地存取
  /// 在用户登录成功的时候可进行设置
  /// * [id] 用户唯一标识
  /// * [token] 用户令牌
  /// * [nickName] 用户昵称
  /// * [uid] 用户uid
  Future<void> setUserInfo({
    required String id,
    String? token,
    String? nickName,
    String? uid,
  }) async {
    Map<String, String> args = {'id': id};
    if (token != null) {
      args['token'] = token;
    }
    if (nickName != null) {
      args['nickName'] = nickName;
    }
    if (uid != null) {
      args['uid'] = uid;
    }
    _channel.invokeMethod(_METHOD_SETUSERINFO, args);
  }

  /// 清除用户id
  Future<void> clearUserID() async {
    _channel.invokeMethod(_METHOD_CLEARUSERID);
  }

  /// 设置搜索到设备时的本地通知
  /// 本地通知发送的策略：
  /// 1）APP在后台，搜索到新的设备
  /// 2）同一局域网IP，在一天内仅发送一次通知
  ///
  /// * [enable] true->代表使用本地通知，false->代表不是用本地通知，默认为true
  /// * [title] 本地通知的title文本，默认文本为“发现一台可以投屏的电视”
  /// * [body] 本地通知的body文本，默认文本为“把你手机上的内容投到大屏电视上，快来试试！”
  Future<void> enableLocalNotification({
    required bool enable,
    String title = '发现一台可以投屏的电视',
    String body = '把你手机上的内容投到大屏电视上，快来试试！',
  }) async {
    _channel.invokeMethod(
      _METHOD_ENABLELOCALNOTIFICATION,
      {
        'enable': enable,
        'title': title,
        'body': body,
      },
    );
  }

  /// 是否打开log文件保存，保存在沙盒Caches文件夹,（最大10M日志）
  /// * [enable] true代表打开，false代表关闭，默认为false
  Future<void> enableLogFileSave({required bool enable}) async {
    _channel.invokeMethod(_METHOD_ENABLELOGFILESAVE, {'enable': enable});
  }
}
