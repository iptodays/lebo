/*
 * @Author: iptoday 
 * @Date: 2021-11-01 14:27:25 
 * @Last Modified by: iptoday
 * @Last Modified time: 2021-11-01 15:05:15
 */
import 'dart:typed_data';

/// 媒体类型
enum LBLelinkMediaType {
  videoOnline, // 在线视频媒体类型
  audioOnline, // 在线音频媒体类型
  photoOnline, // 在线图片媒体类型
  photoLocal, // 本地图片媒体类型
  videoLocal, // 本地视频媒体类型 注意：需要APP层启动本地的webServer，生成一个本地视频的URL
  audioLocal, // 本地音频媒体类型 注意：需要APP层启动本地的webServer，生成一个本地音频的URL
}

/// 媒体格式类型
enum LBLelinkMediaFormatType {
  jpeg, // 图片jpeg格式
  png, // 图片png格式
}

/// 媒体播放循环模式
enum LBLelinkMediaPlayLoopMode {
  defaul, // 默认模式,播完结束
  singleCycle, // 单曲循环
  allCycle, // 全部循环
  orderPlay, // 顺序循环
  randomPlay, // 随机循环
}

/// 媒体资源信息
enum LBPassthMediaAssetMediaType {
  longVideo, // 长视频
  shortVideo, // 短视频
  liveVideo, // 直播
}

class LBLelinkPlayerItem {
  /// 媒体类型
  LBLelinkMediaType mediaType;

  /// 在线媒体的URL
  String? mediaURLString;

  /// 音视频媒体的起播位置，单位秒
  int? startPosition;

  /// 图片媒体的data：当mediaType为LBLelinkMediaTypePhotoLocal，
  /// 以及LBLelinkService的serviceType包含LBLelinkServiceTypeLelink时，
  /// 可将图片转为NSData推送
  Uint8List? mediaData;

  /// 媒体格式,当mediaType为LBLelinkMediaTypePhotoLocal,需指定mediaData的格式
  LBLelinkMediaFormatType? mediaFormatType;

  /// 播放器所需header信息
  Map<String, dynamic>? headerInfo;

  /// 播放加密url地址所需的信息
  LBPlayerAesModel? aesModel;

  /// 播放循环模式
  LBLelinkMediaPlayLoopMode? loopMode;

  /// 片源唯一ID,如需在接收端展现片源相关信息,需设置
  String? mediaId;

  /// 视频媒体类型：直播，短视频，长视频
  LBPassthMediaAssetMediaType? mediaAssetType;

  /// 片源名称,如“阿凡达”,多个以";"分割
  String? mediaName;

  /// 片源导演,多个以";"分割
  String? mediaDirector;

  /// 片源主演,多个以";"分割
  String? mediaActor;

  /// 自定义dlna协议DIDL-Lite中id的值
  String? dlnaDIDLId;

  /// 自定义dlna协议DIDL-Lite中resolution的值
  String? dlnaDIDLResolution;

  LBLelinkPlayerItem({
    required this.mediaType,
    this.mediaURLString,
    this.startPosition,
    this.mediaData,
    this.mediaFormatType,
    this.headerInfo,
    this.aesModel,
    this.loopMode,
    this.mediaId,
    this.mediaAssetType,
    this.mediaName,
    this.mediaDirector,
    this.mediaActor,
    this.dlnaDIDLId,
    this.dlnaDIDLResolution,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['mediaType'] = this.mediaType.index;
    json['mediaURLString'] = this.mediaURLString;
    json['startPosition'] = this.startPosition;
    json['mediaData'] = this.mediaData;
    json['mediaFormatType'] = this.mediaFormatType?.index;
    json['headerInfo'] = this.headerInfo;
    if (this.aesModel != null) {
      json['aesModel'] = this.aesModel!.toJson();
    }
    json['loopMode'] = this.loopMode?.index;
    json['mediaId'] = this.mediaId;
    json['mediaAssetType'] = this.mediaAssetType?.index;
    json['mediaName'] = this.mediaName;
    json['mediaDirector'] = this.mediaDirector;
    json['mediaActor'] = this.mediaActor;
    json['dlnaDIDLId'] = this.dlnaDIDLId;
    json['dlnaDIDLResolution'] = this.dlnaDIDLResolution;
    return json;
  }
}

/// 播放器地址播放所需的AES模型
class LBPlayerAesModel {
  /// 加密模式 ,默认:@"1"
  String? model;

  /// 加密key,必填
  String? key;

  /// 加密iv,必填
  String? iv;

  LBPlayerAesModel({
    this.model,
    this.key,
    this.iv,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['model'] = this.model;
    json['key'] = this.key;
    json['iv'] = this.iv;
    return json;
  }
}
