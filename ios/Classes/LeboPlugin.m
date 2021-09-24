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
  if ([@"enableLog" isEqualToString:method]) {
      [self enableLog:args[@"enable"]];
  } else if ([@"auth" isEqualToString:method]) {
      result([self auth:args[@"appId"] key:args[@"secretKey"]]);
  } else if ([@"setUserInfo" isEqualToString:method]) {
      [self setUserInfo:args];
      
  } else if ([@"clearUserID" isEqualToString:method]) {
      [self clearUserID];
  } else if ([@"getInterestsArray" isEqualToString:method]) {
      result([self getInterestsArray]);
  }
  else if ([@"enableLocalNotification" isEqualToString:method]) {
      [self enableLocalNotification:args];
  } else if ([@"enableLogFileSave" isEqualToString:method]) {
      [self enableLogFileSave:args[@"enable"]];
  } else if ([@"logFileUploadToLeBoServer" isEqualToString:method]) {
      [self logFileUploadToLeBoServer:args];
  }
  else if ([@"searchForLelinkService" isEqualToString:method]) {
      [self searchForLelinkService];
  } else if ([@"stopSearch" isEqualToString:method]) {
      [self stopSearch];
  } else if ([@"reportAPPTVButtonAction" isEqualToString:method]) {
      [self reportAPPTVButtonAction];
  } else if ([@"reportServiceListDisappear" isEqualToString:method]) {
      [self reportServiceListDisappear];
  } else if ([@"connect" isEqualToString:method]) {
      [self connect:args[@"tvUID"]];
  } else if ([@"play" isEqualToString:method]) {
      [self play:args];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
    result(nil);
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

- (void)connect:(NSString *)tvUID {
    LBLelinkService *lelinkService;
    for (LBLelinkService *service in self.lelinkBrowser.lelinkServices) {
        if ([service.tvUID isEqualToString:tvUID]) {
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
    self.lelinkPlayer.lelinkConnection = self.lelinkConnection;
    LBLelinkPlayerItem *lelinkPlayerItem = [[LBLelinkPlayerItem alloc] init];
    lelinkPlayerItem.mediaType = mediaType;
    lelinkPlayerItem.mediaURLString = args[@"mediaURLString"];
    [self.lelinkPlayer playWithItem:lelinkPlayerItem];
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
    if (self.lelinkBrowser == nil) {
        self.lelinkBrowser = [[LBLelinkBrowser alloc] init];
        self.lelinkBrowser.delegate = self;
    }
    return self.lelinkBrowser;
}

- (LBLelinkConnection *)lelinkConnection {
    if (self.lelinkConnection == nil) {
        self.lelinkConnection = [[LBLelinkConnection alloc] init];
        self.lelinkConnection.delegate = self;
    }
    return self.lelinkConnection;
}

- (LBLelinkPlayer *)lelinkPlayer {
    if (self.lelinkPlayer == nil) {
        self.lelinkPlayer = [[LBLelinkPlayer alloc] init];
        self.lelinkPlayer.delegate = self;
    }
    return self.lelinkPlayer;
}

@end
