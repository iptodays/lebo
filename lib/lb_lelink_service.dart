/*
 * @Author: iptoday 
 * @Date: 2021-09-19 16:32:55 
 * @Last Modified by: iptoday
 * @Last Modified time: 2021-09-19 17:15:08
 */

class LBLelinkService {
  /// 服务基本信息
  /// 服务名称，即搜索到的接收端的名称
  late final String lelinkServiceName;

  /// 接收端的唯一标识，公网连接使用
  late final String tvUID;

  /// 接收端的IP地址
  late final String ipAddress;

  /// linux端口
  late final int remotePort;

  /// android端口
  late final int port;

  /// 乐联服务端口
  late final int lelinkPort;

  /// 接收端包名
  /// TV端乐播投屏apk的包名为com.hpplay.happyplay.aw，
  /// 可在设备列表中判断receviverPackageName是否等于此包名，
  /// UI上可以加上推荐二字，用户的投屏体验更好
  late final String receviverPackageName;

  /// 接收端DLNA的uuid，注意此字段只针对特殊渠道有效，非通用字段
  late final String uuid;

  /// 接收端是否有可升级的新版本
  /// 此属性是搜到TV端乐播投屏apk有新版可更新时，可提示用户升级接收端，体验更好
  late final String hasNewVersion;

  /// (非必要的)别名，开发者可开放出来供用户修改服务名称的别名，方便用户自己识别和区分自己的服务
  late String alias;

  /// (非必要的)发送端登录的账号
  late String vuuid;

  /// (非必要的)是否为常用
  late bool frequentlyUsed;

  /// 曾经连接过的服务
  late bool onceConnected;

  /// 上次连接过的服务
  late bool lastTimeConnected;

  /// 是否从二维码获得的设备
  late final bool fromQRCode;

  /// 接收端的渠道id
  late final String appID;

  /// 接收端的mirrorReconnect,内部使用
  late final int mirrorReconnect;

  /// 服务可用状态，该服务包含三种类型的服务：乐联服务、DLNA服务和公网服务
  /// 服务是否可用，三个服务中的任意一个可用，则isLelinkServiceAvailable为true，否则为false
  late final bool lelinkServiceAvailable;

  /// 乐联服务是否可用
  late final bool innerLelinkServiceAvailable;

  /// DLNA服务是否可用
  late final bool upnpServiceAvailable;

  /// 公网服务是否可用
  late final bool imServiceAvailable;

  LBLelinkService({
    required this.lelinkServiceName,
    required this.tvUID,
    required this.ipAddress,
    required this.remotePort,
    required this.port,
    required this.lelinkPort,
    required this.receviverPackageName,
    required this.uuid,
    required this.hasNewVersion,
    required this.appID,
    required this.mirrorReconnect,
    required this.lelinkServiceAvailable,
    required this.innerLelinkServiceAvailable,
    required this.upnpServiceAvailable,
    required this.imServiceAvailable,
    required this.fromQRCode,
    required this.alias,
    required this.vuuid,
    required this.frequentlyUsed,
    required this.onceConnected,
    required this.lastTimeConnected,
  });

  LBLelinkService.fromJson(Map<String, dynamic> json) {
    lelinkServiceName = json['lelinkServiceName'];
    tvUID = json['tvUID'];
    ipAddress = json['ipAddress'];
    remotePort = json['remotePort'];
    port = json['port'];
    lelinkPort = json['lelinkPort'];
    receviverPackageName = json['receviverPackageName'];
    uuid = json['uuid'];
    hasNewVersion = json['hasNewVersion'];
    alias = json['alias'];
    vuuid = json['vuuid'];
    frequentlyUsed = json['frequentlyUsed'];
    onceConnected = json['onceConnected'];
    lastTimeConnected = json['lastTimeConnected'];
    fromQRCode = json['fromQRCode'];
    appID = json['appID'];
    mirrorReconnect = json['mirrorReconnect'];
    lelinkServiceAvailable = json['lelinkServiceAvailable'];
    innerLelinkServiceAvailable = json['innerLelinkServiceAvailable'];
    upnpServiceAvailable = json['upnpServiceAvailable'];
    imServiceAvailable = json['imServiceAvailable'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['lelinkServiceName'] = this.lelinkServiceName;
    json['tvUID'] = this.tvUID;
    json['ipAddress'] = this.ipAddress;
    json['remotePort'] = this.remotePort;
    json['port'] = this.port;
    json['lelinkPort'] = this.lelinkPort;
    json['receviverPackageName'] = this.receviverPackageName;
    json['uuid'] = this.uuid;
    json['hasNewVersion'] = this.hasNewVersion;
    json['alias'] = this.alias;
    json['vuuid'] = this.vuuid;
    json['frequentlyUsed'] = this.frequentlyUsed;
    json['onceConnected'] = this.onceConnected;
    json['lastTimeConnected'] = this.lastTimeConnected;
    json['fromQRCode'] = this.fromQRCode;
    json['appID'] = this.appID;
    json['mirrorReconnect'] = this.mirrorReconnect;
    json['lelinkServiceAvailable'] = this.lelinkServiceAvailable;
    json['innerLelinkServiceAvailable'] = this.innerLelinkServiceAvailable;
    json['upnpServiceAvailable'] = this.upnpServiceAvailable;
    json['imServiceAvailable'] = this.imServiceAvailable;
    return json;
  }
}