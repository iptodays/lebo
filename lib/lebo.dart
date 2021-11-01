import 'dart:async';
import 'package:flutter/services.dart';
import 'lb_lelink_player_item.dart';
import 'lb_lelink_service.dart';
import 'lb_lelink_progress_info.dart';

export 'lb_lelink_player_item.dart';
export 'lb_lelink_progress_info.dart';
export 'lb_lelink_service.dart';

/// 日志上报问题反馈类型
enum LBLogReportProblemType {
  caton, //播放片源卡顿
  blackScreenHaveVoice, //播放片源黑屏有声音
  notCanPlay, //播放片源无法播放
  crashBack, //播放片源闪退
  imageCompression, //播放片源画面压缩
  loadFailed, //播放片源加载失败
  soundImageNotSync, //播放片源卡顿
  other, //其它问题
}

/// 播放状态
enum LBLelinkPlayStatus {
  unkown, // 未知状态
  loading, // 视频正在加载状态
  playing, // 正在播放状态
  pause, // 暂停状态
  stopped, // 退出播放状态
  commpleted, // 播放完成状态
  error, // 播放错误
}

enum LBPlaySpeedRateType {
  r_1_0X, // 1.0
  r_0_5X, // 0.5
  r_0_75X, // 0.75
  r_1_25X, // 1.25
  r_1_5X, // 1.5
  r_2_0X, // 2.0
}

class Lebo {
  Lebo._();

  static Lebo get instance => _instance;
  static late final Lebo _instance = Lebo._();

  /// 如何使用投屏功能
  String get helpGuide => 'http://cdn.hpplay.com.cn/h5/app/helpGuide.html';

  bool get isAuthorized => _isAuthorized;
  bool _isAuthorized = false;

  static const String _METHOD_GETVERSION = 'getVersion';
  static const String _METHOD_ENABLELOG = 'enableLog';
  static const String _METHOD_AUTH = 'auth';
  static const String _METHOD_SETUSERINFO = 'setUserInfo';
  static const String _METHOD_CLEARUSERID = 'clearUserID';
  static const String _METHOD_ENABLELOCALNOTIFICATION =
      'enableLocalNotification';
  static const String _METHOD_ENABLELOGFILESAVE = 'enableLogFileSave';
  static const String _METHOD_GETINTERESTSARRAY = 'getInterestsArray';
  static const String _METHOD_SEARCHFORLELINKSERVICE = 'searchForLelinkService';
  static const String _METHOD_STOPSEARCH = 'stopSearch';
  static const String _METHOD_CONNECT = 'connect';
  static const String _METHOD_DISCONNECT = 'disConnect';
  static const String _METHOD_PLAY = 'play';
  static const String _METHOD_PAUSE = 'pause';
  static const String _METHOD_RESUMEPLAY = 'resumePlay';
  static const String _METHOD_SEEKTO = 'seekTo';
  static const String _METHOD_STOP = 'stop';
  static const String _METHOD_SETVOLUME = 'setVolume';
  static const String _METHOD_ADDVOLUME = 'addVolume';
  static const String _METHOD_REDUVEVOLUME = 'reduceVolume';
  static const String _METHOD_ISSUPPORTCHANGEPLAYSPEED =
      'isSupportChangePlaySpeed';
  static const String _METHOD_SETPLAYSPEEDWITHRATE = 'setPlaySpeedWithRate';
  static const String _METHOD_CANPLAYMEDIA = 'canPlayMedia';
  static const String _METHOD_REPORTAPPTVBUTTONACTION =
      'reportAPPTVButtonAction';
  static const String _METHOD_REPORTSERVICELISTDISAPPEAR =
      'reportServiceListDisappear';
  static const String _METHOD_LOGFILEUPLOADTOLEBOSERVER =
      'logFileUploadToLeBoServer';

  static const String _METHOD_LOGFILEUPLOADCALLBACK = 'logFileUploadCallback';
  static const String _METHOD_LELINKBROWSER = 'lelinkBrowser';
  static const String _METHOD_LELINKCONNECTION = 'lelinkConnection';
  static const String _METHOD_LELINKPLAYER = 'lelinkPlayer';

  /// 日志上传成功与否回调
  late void Function(bool, String, int?, String?)? logFileUploadCallback;

  /// 搜索错误信息会在此代理方法中回调出来
  late void Function(int, String)? lelinkBrowserError;

  /// 搜索到服务时，将设备列表在此方法中回调出来
  /// 注意：如果不调用stop，则当有服务信息和状态更新以及新服务加入网络或服务退出网络时，
  /// 会调用此代理，将新的设备列表回调出来
  late void Function(List<LBLelinkService>)? lelinkBrowser;

  /// 创建服务连接错误信息会在此代理方法中回调出来
  late void Function(int, String)? lelinkConnectionError;

  /// 创建服务连接成功
  late void Function(LBLelinkService)? lelinkConnection;

  /// 断开服务连接
  late void Function(LBLelinkService)? lelinkDisConnection;

  /// 播放错误回调，根据错误信息进行相关的处理
  late void Function(int, String)? lelinkPlayerError;

  /// 播放状态回调
  late void Function(LBLelinkPlayStatus)? lelinkPlayerStatus;

  /// 播放进度信息回调
  late void Function(LBLelinkProgressInfo)? lelinkPlayer;

  late final MethodChannel _channel = const MethodChannel('com.iptoday.lebo')
    ..setMethodCallHandler(_setMethodCallHandler);

  /// 由原生调用flutter的处理
  Future<dynamic> _setMethodCallHandler(MethodCall call) async {
    var args = call.arguments;
    if (!(args is Map)) {
      return;
    }
    switch (call.method) {
      case _METHOD_LOGFILEUPLOADCALLBACK:
        _logFileUploadCallback(args);
        break;
      case _METHOD_LELINKBROWSER:
        _lelinkBrowser(args);
        break;
      case _METHOD_LELINKCONNECTION:
        _lelinkConnection(args);
        break;
      case _METHOD_LELINKPLAYER:
        _lelinkPlayer(args);
        break;

      default:
    }
  }

  /// 获取当前SDK版本
  Future<int> getVersion() async {
    return await _channel.invokeMethod(_METHOD_GETVERSION);
  }

  /// 是否打开log，打印输出在控制台
  /// * [enable] true代表打开，false代表关闭，默认为false
  Future<void> enableLog({required bool enable}) async {
    await _channel.invokeMethod(_METHOD_ENABLELOG, {'enable': enable});
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
    if (!_isAuthorized) {
      var result = await _channel.invokeMethod(
        _METHOD_AUTH,
        {
          'appId': appId,
          'secretKey': secretKey,
        },
      );
      _isAuthorized = result['result'];
      if (error != null &&
          result.containsKey('code') &&
          result.containsKey('message')) {
        error(
          result['code'],
          result['message'],
        );
      }
    }
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
    await _channel.invokeMethod(_METHOD_SETUSERINFO, args);
  }

  /// 清除用户id
  Future<void> clearUserID() async {
    await _channel.invokeMethod(_METHOD_CLEARUSERID);
  }

  /// 获取兴趣数组
  Future<List?> getInterestsArray({
    void Function(int? code, String? message)? error,
  }) async {
    var reslut = await _channel.invokeMethod(_METHOD_GETINTERESTSARRAY);
    if (error != null &&
        reslut.containsKey('code') &&
        reslut.containsKey('message')) {
      error(
        reslut['code'],
        reslut['message'],
      );
    }
    return reslut['reslut'];
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
    await _channel.invokeMethod(
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
    await _channel.invokeMethod(_METHOD_ENABLELOGFILESAVE, {'enable': enable});
  }

  /// log文件上传到乐播服务器
  /// * [problemType] 问题类型
  /// * [contactInfo] 用户联系信息
  Future<void> logFileUploadToLeBoServer({
    required LBLogReportProblemType type,
    required String contactInfo,
  }) async {
    await _channel.invokeListMethod(
      _METHOD_LOGFILEUPLOADTOLEBOSERVER,
      {
        'type': type.index,
        'contactInfo': contactInfo,
      },
    );
  }

  /// 搜索服务
  Future<void> searchForLelinkService() async {
    await _channel.invokeMethod(_METHOD_SEARCHFORLELINKSERVICE);
  }

  /// 停止搜索，停止搜索后设备列表不会被清空，但是不会更新列表了
  Future<void> stopSearch() async {
    await _channel.invokeMethod(_METHOD_STOPSEARCH);
  }

  /// 连接设备
  Future<void> connect(LBLelinkService service) async {
    await _channel.invokeMethod(_METHOD_CONNECT, service.toJson());
  }

  /// 取消连接
  Future<void> disConnect() async {
    await _channel.invokeMethod(_METHOD_DISCONNECT);
  }

  /// 播放
  /// * [LBLelinkPlayerItem]: 播放资源对象
  Future<void> play(LBLelinkPlayerItem item) async {
    await _channel.invokeMethod(_METHOD_PLAY, item.toJson());
  }

  /// 暂停播放
  Future<void> pause() async {
    await _channel.invokeMethod(_METHOD_PAUSE);
  }

  /// 继续播放
  Future<void> resumePlay() async {
    await _channel.invokeMethod(_METHOD_RESUMEPLAY);
  }

  /// 进度调节
  /// * [seconds]: 调节进度的位置，单位秒
  Future<void> seekTo(int seconds) async {
    await _channel.invokeMethod(
      _METHOD_SEEKTO,
      {'seconds': seconds},
    );
  }

  /// 退出播放
  Future<void> stop() async {
    await _channel.invokeMethod(_METHOD_STOP);
  }

  /// 设置音量值
  /// * [value]: 音量值，范围0 ~ 100
  Future<void> setVolume(int value) async {
    await _channel.invokeMethod(_METHOD_SETVOLUME, {'value': value});
  }

  /// 增加音量
  Future<void> addVolume() async {
    await _channel.invokeMethod(_METHOD_ADDVOLUME);
  }

  /// 减小音量
  Future<void> reduceVolume() async {
    await _channel.invokeMethod(_METHOD_REDUVEVOLUME);
  }

  /// 查询倍速播放能力
  Future<bool> isSupportChangePlaySpeed() async {
    return await _channel.invokeMethod(_METHOD_ISSUPPORTCHANGEPLAYSPEED);
  }

  /// 设置播放速率
  Future<void> setPlaySpeedWithRate(LBPlaySpeedRateType rateType) async {
    await _channel.invokeMethod(
      _METHOD_SETPLAYSPEEDWITHRATE,
      {'rateType': rateType.index},
    );
  }

  /// 支持的媒体类型判断，
  /// 在调用- (void)playWithItem:(LBLelinkPlayerItem *)item;之前，
  /// 先进行判断是否支持该类型的媒体。
  /// 注意：此接口在连接成功后有效，如果没有连接成功，则返回的都是NO
  /// @return YES支持，NO不支持
  Future<bool> canPlayMedia(LBLelinkMediaType mediaType) async {
    return await _channel.invokeMethod(
      _METHOD_CANPLAYMEDIA,
      {'mediaType': mediaType.index},
    );
  }

  /// 投屏行为埋点统计（为了帮助接入方分析用户投屏行为提供足够的数据支撑，需要调用以下两个接口，可选项）
  /// 点击搜索设备时上报
  Future<void> reportAPPTVButtonAction() async {
    await _channel.invokeMethod(_METHOD_REPORTAPPTVBUTTONACTION);
  }

  /// 设备列表消失
  Future<void> reportServiceListDisappear() async {
    await _channel.invokeMethod(_METHOD_REPORTSERVICELISTDISAPPEAR);
  }

  /// 日志是否上传成功
  void _logFileUploadCallback(args) async {
    if (this.logFileUploadCallback != null) {
      this.logFileUploadCallback!(
        args['succeed'],
        args['euqid'],
        args['code'],
        args['message'],
      );
    }
  }

  /// LBLelinkBrowserDelegate
  /// 开启搜索后的回调
  void _lelinkBrowser(args) async {
    if (this.lelinkBrowserError != null &&
        args.containsKey('code') &&
        args.containsKey('message')) {
      this.lelinkBrowserError!(args['code'], args['message']);
    }
    if (this.lelinkBrowser != null &&
        args.containsKey('services') &&
        args['services'] is List) {
      this.lelinkBrowser!(
        args['services'].map<LBLelinkService>(
          (e) {
            return LBLelinkService.fromJson(e);
          },
        ).toList(),
      );
    }
  }

  /// LBLelinkConnectionDelegate
  /// 连接服务的回调
  void _lelinkConnection(args) async {
    if (this.lelinkConnectionError != null &&
        args.containsKey('code') &&
        args.containsKey('message')) {
      this.lelinkConnectionError!(args['code'], args['message']);
    }
    if (this.lelinkConnection != null &&
        args.containsKey('service') &&
        args.containsKey('connection')) {
      this.lelinkConnection!(LBLelinkService.fromJson(args['service']));
    }
    if (this.lelinkDisConnection != null &&
        args.containsKey('service') &&
        args.containsKey('didConnect')) {
      this.lelinkDisConnection!(LBLelinkService.fromJson(args['service']));
    }
  }

  /// LBLelinkPlayerDelegate
  /// 播放进度信息回调
  void _lelinkPlayer(args) async {
    if (this.lelinkPlayerError != null &&
        args.containsKey('code') &&
        args.containsKey('message')) {
      this.lelinkPlayerError!(args['code'], args['message']);
    }
    if (this.lelinkPlayerStatus != null && args.containsKey('status')) {
      print('status = ${args['status']}');
    }
    if (this.lelinkPlayer != null &&
        args.containsKey('currentTime') &&
        args.containsKey('duration')) {
      this.lelinkPlayer!(LBLelinkProgressInfo.fromJson(args));
    }
  }
}
