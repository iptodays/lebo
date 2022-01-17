#import "LeboPlugin.h"
#import <LBLelinkKit/LBLelinkKit.h>


@interface LeboPlugin()<
LBLelinkBrowserDelegate,
LBLelinkConnectionDelegate,
LBLelinkPlayerDelegate>

@property(nonatomic, strong)LBLelinkBrowser *lelinkBrowser;

@property(nonatomic, strong)LBLelinkConnection *lelinkConnection;

@property(nonatomic, strong)LBLelinkPlayer *lelinkPlayer;

@end

FlutterMethodChannel *channel;
@implementation LeboPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel
      methodChannelWithName:@"com.iptoday.lebo"
            binaryMessenger:[registrar messenger]];
  LeboPlugin* instance = [[LeboPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *method = call.method;
    NSDictionary *args = call.arguments;
    if ([@"getVersion" isEqualToString:method]) {
        result(@([self getVersion]));
    } else if ([@"enableLog" isEqualToString:method]) {
      [self enableLog:args[@"enable"]];
  } else if ([@"auth" isEqualToString:method]) {
      result([self auth:args[@"appId"] key:args[@"secretKey"]]);
  } else if ([@"setUserInfo" isEqualToString:method]) {
      [self setUserInfo:args];
      
  } else if ([@"clearUserID" isEqualToString:method]) {
      [self clearUserID];
  } else if ([@"getInterestsArray" isEqualToString:method]) {
      result([self getInterestsArray]);
  } else if ([@"enableLocalNotification" isEqualToString:method]) {
      [self enableLocalNotification:args];
  } else if ([@"enableLogFileSave" isEqualToString:method]) {
      [self enableLogFileSave:args[@"enable"]];
  } else if ([@"logFileUploadToLeBoServer" isEqualToString:method]) {
      [self logFileUploadToLeBoServer:args];
  } else if ([@"searchForLelinkService" isEqualToString:method]) {
      [self searchForLelinkService];
  } else if ([@"stopSearch" isEqualToString:method]) {
      [self stopSearch];
  } else if ([@"reportAPPTVButtonAction" isEqualToString:method]) {
      [self reportAPPTVButtonAction];
  } else if ([@"reportServiceListDisappear" isEqualToString:method]) {
      [self reportServiceListDisappear];
  } else if ([@"connect" isEqualToString:method]) {
      [self connect:args[@"ipAddress"]];
  } else if ([@"play" isEqualToString:method]) {
      [self play:args];
  } else if ([@"disConnect" isEqualToString:method]) {
      [self disConnect];
  } else if ([@"pause" isEqualToString:method]) {
      [self pause];
  } else if ([@"resumePlay" isEqualToString:method]) {
      [self resumePlay];
  } else if ([@"seekTo" isEqualToString:method]) {
      [self seekTo:[args[@"seconds"] intValue]];
  } else if ([@"stop" isEqualToString:method]) {
      [self stop];
  } else if ([@"setVolume" isEqualToString:method]) {
      [self setVolume:[args[@"value"] intValue]];
  } else if ([@"addVolume" isEqualToString:method]) {
      [self addVolume];
  } else if ([@"reduceVolume" isEqualToString:method]) {
      [self reduceVolume];
  } else if ([@"isSupportChangePlaySpeed" isEqualToString:method]) {
      result(@([self isSupportChangePlaySpeed]));
  } else if ([@"setPlaySpeedWithRate" isEqualToString:method]) {
      [self setPlaySpeedWithRate:[args[@"rateType"] intValue]];
  } else if ([@"canPlayMedia" isEqualToString:method]) {
      result(@([self canPlayMedia:[args[@"mediaType"] intValue]]));
  }
  else {
    result(FlutterMethodNotImplemented);
  }
    result(nil);
}

- (NSInteger)getVersion {
    return [LBLelinkKit version];
}

- (void)enableLog:(BOOL)enable {
    [LBLelinkKit enableLog:enable];
}


- (NSMutableDictionary *)auth:(NSString *)appId key:(NSString *)secretKey {
    NSError *error;
    NSMutableDictionary *args = @{}.mutableCopy;
    BOOL r = [LBLelinkKit authWithAppid:appId secretKey:secretKey error:&error];
    args[@"result"] = @(r);
    if (error != nil) {
        args[@"code"] = @(error.code);
        args[@"message"] = error.localizedDescription;
    }
    return args;
}

- (void)setUserInfo:(NSDictionary *)args {
    switch (args.allKeys.count) {
        case 1:
            [LBLelinkKit setUserID:args[@"id"]];
            break;
        case 2:
            [LBLelinkKit setUserID:args[@"id"] token:args[@"token"]];
            break;
        case 3:
            [LBLelinkKit setUserID:args[@"id"]
                             token:args[@"token"]
                          nickName:args[@"nickName"]];
            break;
        case 4:
            [LBLelinkKit setUserID:args[@"id"]
                             token:args[@"token"]
                          nickName:args[@"nickName"]
                               uid:args[@"uid"]];
            break;
        default:
            break;
    }
    
}

- (void)clearUserID {
    [LBLelinkKit clearUserID];
}

- (NSMutableDictionary *)getInterestsArray {
    NSError *error;
    NSArray *arry = [LBLelinkKit getinterestsArray:&error];
    NSMutableDictionary *args = @{}.mutableCopy;
    if (error != nil) {
        args[@"result"] = @[];
        args[@"code"] = @(error.code);
        args[@"message"] = error.localizedDescription;
    } else {
        args[@"result"] = arry;
    }
    return args;
}

- (void)enableLocalNotification:(NSDictionary *)args {
    [LBLelinkKit enableLocalNotification:args[@"enable"]
                              alertTitle:args[@"title"]
                               alertBody:args[@"body"]];
}

- (void)enableLogFileSave:(BOOL)enable {
    [LBLelinkKit enableLogFileSave:enable];
}

- (void)logFileUploadToLeBoServer:(NSDictionary *)args {
    LBLogReportProblemType problemType;
    switch ([args[@"problemType"] intValue]) {
        case 0:
            problemType =LBLogReportProblemTypePlayerCaton;
            break;
        case 1:
            problemType =LBLogReportProblemTypePlayerBlackScreenHaveVoice;
            break;
        case 2:
            problemType =LBLogReportProblemTypePlayerNotCanPlay;
            break;
        case 3:
            problemType =LBLogReportProblemTypePlayerCrashBack;
            break;
        case 4:
            problemType =LBLogReportProblemTypePlayerImageCompression;
            break;
        case 5:
            problemType =LBLogReportProblemTypePlayerLoadFailed;
            break;
        case 6:
            problemType =LBLogReportProblemTypePlayerSoundImageNotSync;
            break;
        default:
            problemType =LBLogReportProblemTypePlayerOther;
            break;
    }
    [LBLelinkKit logFileUploadToLeBoServerWithProblemType:problemType userContactInfo:args[@"contactInfo"] callBlock:^(BOOL succeed, NSString * _Nullable euqid, NSError * _Nullable error) {
        NSMutableDictionary *args = @{
            @"succeed": @(succeed),
            @"euqid": euqid,
        }.mutableCopy;
        if (error != nil) {
            args[@"code"]= @(error.code);
            args[@"message"] = error.localizedDescription;
        }
        [channel invokeMethod:@"logFileUploadCallback" arguments:args];
    }];
}

- (void)searchForLelinkService {
    [self.lelinkBrowser searchForLelinkService];
}

- (void)stopSearch {
    [self.lelinkBrowser stop];
}

- (void)reportAPPTVButtonAction {
    [LBLelinkBrowser reportAPPTVButtonAction];
}

- (void)reportServiceListDisappear {
    [self.lelinkBrowser reportServiceListDisappear];
}

- (void)connect:(NSString *)ipAddress {
    LBLelinkService *lelinkService;
    for (LBLelinkService *service in self.lelinkBrowser.lelinkServices) {
        if ([service.ipAddress isEqualToString:ipAddress]) {
            lelinkService = service;
        }
    }
    self.lelinkConnection.lelinkService = lelinkService;
    [self.lelinkConnection connect];
}

- (void)disConnect {
    [self.lelinkConnection disConnect];
}

- (void)play:(NSDictionary *)args {
    LBLelinkPlayerItem *lelinkPlayerItem = [[LBLelinkPlayerItem alloc] init];
    LBLelinkMediaType mediaType;
    switch ([args[@"mediaType"] intValue]) {
        case 0:
            mediaType = LBLelinkMediaTypeVideoOnline;
            break;
        case 1:
            mediaType = LBLelinkMediaTypeAudioOnline;
            break;
        case 2:
            mediaType = LBLelinkMediaTypePhotoOnline;
            break;
        case 3:
            mediaType = LBLelinkMediaTypePhotoLocal;
            break;
        case 4:
            mediaType = LBLelinkMediaTypeVideoLocal;
            break;
        default:
            mediaType = LBLelinkMediaTypeAudioLocal;
            break;
    }
    lelinkPlayerItem.mediaType = mediaType;
    if (![args[@"mediaName"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaName = args[@"mediaName"];
    }
    if (![args[@"mediaURLString"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaURLString = args[@"mediaURLString"];
    }
    if (![args[@"startPosition"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.startPosition = [args[@"startPosition"] intValue];
    }
    if (![args[@"mediaData"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaData = args[@"mediaData"];
    }
    if (![args[@"mediaFormatType"] isKindOfClass:NSNull.class]) {
        LBLelinkMediaFormatType mediaFormatType;
        switch ([args[@"mediaFormatType"] intValue]) {
            case 0:
                mediaFormatType = LBLelinkMediaFormatTypePhotoJpeg;
                break;
            default:
                mediaFormatType = LBLelinkMediaFormatTypePhotoPng;
                break;
        }
        lelinkPlayerItem.mediaFormatType = mediaFormatType;
    }
    if (![args[@"headerInfo"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.headerInfo = args[@"headerInfo"];
    }
    if (![args[@"aesModel"] isKindOfClass:NSNull.class]) {
        LBPlayerAesModel *aesModel = [[LBPlayerAesModel alloc] init];
        NSDictionary *params = args[@"aesModel"];
        aesModel.model = params[@"model"];
        aesModel.key = params[@"key"];
        aesModel.iv = params[@"iv"];
        lelinkPlayerItem.aesModel = aesModel;
    }
    if (![args[@"loopMode"] isKindOfClass:NSNull.class]) {
        LBLelinkMediaPlayLoopMode loopMode;
        switch ([args[@"loopMode"] intValue]) {
            case 0:
                loopMode = LBLelinkMediaPlayLoopModeDefault;
                break;
            case 1:
                loopMode = LBLelinkMediaPlayLoopModeSingleCycle;
                break;
            case 2:
                loopMode = LBLelinkMediaPlayLoopModeAllCycle;
                break;
            case 3:
                loopMode = LBLelinkMediaPlayLoopModeOrderPlay;
                break;
            default:
                loopMode = LBLelinkMediaPlayLoopModeRandomPlay;
                break;
        }
        lelinkPlayerItem.loopMode = loopMode;
    }
    if (![args[@"mediaId"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaId = args[@"mediaId"];
    }
    if (![args[@"mediaAssetType"] isKindOfClass:NSNull.class]) {
        LBPassthMediaAssetMediaType mediaAssetType;
        switch ([args[@"mediaAssetType"] intValue]) {
            case 0:
                mediaAssetType = LBPassthMediaAssetMediaTypeLongVideo;
                break;
            case 1:
                mediaAssetType = LBPassthMediaAssetMediaTypeShortVideo;
                break;
            default:
                mediaAssetType = LBPassthMediaAssetMediaTypeLiveVideo;
                break;
        }
        lelinkPlayerItem.mediaAssetType = mediaAssetType;
    }
    if (![args[@"mediaName"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaName = args[@"mediaName"];
    }
    if (![args[@"mediaDirector"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaDirector = args[@"mediaDirector"];
    }
    if (![args[@"mediaActor"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.mediaActor = args[@"mediaActor"];
    }
    if (![args[@"dlnaDIDLId"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.dlnaDIDLId = args[@"dlnaDIDLId"];
    }
    if (![args[@"dlnaDIDLResolution"] isKindOfClass:NSNull.class]) {
        lelinkPlayerItem.dlnaDIDLResolution = args[@"dlnaDIDLResolution"];
    }
    self.lelinkPlayer.lelinkConnection = self.lelinkConnection;
    [self.lelinkPlayer playWithItem:lelinkPlayerItem];
}


- (void)pause {
    [self.lelinkPlayer pause];
}

- (void)resumePlay {
    [self.lelinkPlayer resumePlay];
}

- (void)seekTo:(int)seconds {
    [self.lelinkPlayer seekTo:seconds];
}

- (void)stop {
    [self.lelinkPlayer stop];
}

- (void)setVolume:(int)volume {
    [self.lelinkPlayer setVolume:volume];
}

- (void)addVolume {
    [self.lelinkPlayer addVolume];
}

- (void)reduceVolume {
    [self.lelinkPlayer reduceVolume];
}

- (BOOL)isSupportChangePlaySpeed {
    return [self.lelinkPlayer isSupportChangePlaySpeed];
}

- (void)setPlaySpeedWithRate:(int)index {
    LBPlaySpeedRateType rateType;
    switch (index) {
        case 0:
            rateType = LBPlaySpeedRate1_0X;
            break;
        case 1:
            rateType = LBPlaySpeedRate0_5X;
            break;
        case 2:
            rateType = LBPlaySpeedRate0_75X;
            break;
        case 3:
            rateType = LBPlaySpeedRate1_25X;
            break;
        case 4:
            rateType = LBPlaySpeedRate1_5X;
            break;
        default:
            rateType = LBPlaySpeedRate2_0X;
            break;
    }
    [self.lelinkPlayer setPlaySpeedWithRate:rateType];
}

- (BOOL)canPlayMedia:(int)index {
    LBLelinkMediaType mediaType;
    switch (index) {
        case 0:
            mediaType = LBLelinkMediaTypeVideoOnline;
            break;
        case 1:
            mediaType = LBLelinkMediaTypeAudioOnline;
            break;
        case 2:
            mediaType = LBLelinkMediaTypePhotoOnline;
            break;
        case 3:
            mediaType = LBLelinkMediaTypePhotoLocal;
            break;
        case 4:
            mediaType = LBLelinkMediaTypeVideoLocal;
            break;
        default:
            mediaType = LBLelinkMediaTypeAudioLocal;
            break;
    }
    return [self.lelinkPlayer canPlayMedia:mediaType];
}

#pragma mark - LBLelinkBrowserDelegate
// 方便调试，错误信息会在此代理方法中回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser onError:(NSError *)error {
    [channel invokeMethod:@"lelinkBrowser" arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
    }];
}

// 搜索到服务时，会调用此代理方法，将设备列表在此方法中回调出来
// 注意：如果不调用stop，则当有服务信息和状态更新以及新服务加入网络或服务退出网络时，
// 会调用此代理，将新的设备列表回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser didFindLelinkServices:(NSArray<LBLelinkService *> *)services {
    NSMutableArray<NSDictionary *>*array = @[].mutableCopy;
    for (int i = 0; i< services.count; i ++) {
        [array addObject:services[i].dict];
    }
    [channel invokeMethod:@"lelinkBrowser" arguments:@{
        @"services":array,
    }];
}

#pragma mark - LBLelinkConnectionDelegate
- (void)lelinkConnection:(LBLelinkConnection *)connection onError:(NSError *)error {
    [channel invokeMethod:@"lelinkConnection" arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
    }];
}

- (void)lelinkConnection:(LBLelinkConnection *)connection didConnectToService:(LBLelinkService *)service {
    [channel invokeMethod:@"lelinkConnection" arguments:@{
        @"connection":@(true),
        @"service": [service dict],
    }];
}

- (void)lelinkConnection:(LBLelinkConnection *)connection disConnectToService:(LBLelinkService *)service {
    [channel invokeMethod:@"lelinkConnection" arguments:@{
        @"didConnect":@(true),
        @"service": [service dict],
    }];
}

#pragma mark - LBLelinkPlayerDelegate
// 播放错误代理回调，根据错误信息进行相关的处理
- (void)lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error {
    [channel invokeMethod:@"lelinkPlayer" arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
    }];
}

// 播放状态代理回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus {
    [channel invokeMethod:@"lelinkPlayer" arguments:@{
        @"status": @(playStatus),
    }];
}

// 播放进度信息回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo {
    [channel invokeMethod:@"lelinkPlayer" arguments:@{
        @"currentTime": @(progressInfo.currentTime),
        @"duration": @(progressInfo.duration),
    }];
}

- (LBLelinkBrowser *)lelinkBrowser {
    if (_lelinkBrowser == nil) {
        _lelinkBrowser = [[LBLelinkBrowser alloc] init];
        _lelinkBrowser.delegate = self;
    }
    return _lelinkBrowser;
}

- (LBLelinkConnection *)lelinkConnection {
    if (_lelinkConnection == nil) {
        _lelinkConnection = [[LBLelinkConnection alloc] init];
        _lelinkConnection.delegate = self;
    }
    return _lelinkConnection;
}

- (LBLelinkPlayer *)lelinkPlayer {
    if (_lelinkPlayer == nil) {
        _lelinkPlayer = [[LBLelinkPlayer alloc] init];
        _lelinkPlayer.delegate = self;
    }
    return _lelinkPlayer;
}

@end
