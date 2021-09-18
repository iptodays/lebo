#import "LeboPlugin.h"
#import <LBLelinkKit/LBLelinkKit.h>

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
  if ([@"enableLog" isEqualToString:call.method]) {
      [self enableLog:call.arguments[@"enable"]];
  } else if ([@"auth" isEqualToString:call.method]) {
      result([self auth:call.arguments[@"appId"] key:call.arguments[@"secretKey"]]);
  } else if ([@"setUserInfo" isEqualToString:call.method]) {
      NSDictionary *args = call.arguments;
      switch (args.allKeys.count) {
          case 1:
              [self setUserID:args[@"id"]];
              break;
          case 2:
              [self setUserID:args[@"id"] token:args[@"token"]];
              break;
          case 3:
              [self setUserID:args[@"id"]
                        token:args[@"token"]
                     nickName:args[@"nickName"]];
              break;
          case 4:
              [self setUserID:args[@"id"]
                        token:args[@"token"]
                     nickName:args[@"nickName"]
                          uid:args[@"uid"]];
              break;
          default:
              break;
      }
  } else if ([@"clearUserID" isEqualToString:call.method]) {
      [self clearUserID];
  } else if ([@"enableLocalNotification" isEqualToString:call.method]) {
      [self enableLocalNotification:call.arguments[@"enable"]
                         alertTitle:call.arguments[@"title"]
                          alertBody:call.arguments[@"body"]];
  } else if ([@"enableLogFileSave" isEqualToString:call.method]) {
      [self enableLogFileSave:call.arguments[@"enable"]];
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

- (void)setUserID:(NSString *)userId {
    [LBLelinkKit setUserID:userId];
}

- (void)setUserID:(NSString *)userID token:(NSString *)token {
    [LBLelinkKit setUserID:userID token:token];
}

- (void)setUserID:(NSString *)userID token:(NSString *)token nickName:(NSString *)nickName {
    [LBLelinkKit setUserID:userID token:token nickName:nickName];
}

- (void)setUserID:(NSString *)userID token:(NSString *)token nickName:(NSString *)nickName uid:(NSString *)uid {
    [LBLelinkKit setUserID:userID token:token nickName:nickName uid:uid];
}

- (void)clearUserID {
    [LBLelinkKit clearUserID];
}

- (NSArray *)getinterestsArray {
    NSError *error;
    return [LBLelinkKit getinterestsArray:&error];
}

- (void)enableLocalNotification:(BOOL)enable alertTitle:(NSString *)title alertBody:(NSString *)body {
    [LBLelinkKit enableLocalNotification:enable alertTitle:title alertBody:body];
}

- (void)enableLogFileSave:(BOOL)enable {
    [LBLelinkKit enableLogFileSave:enable];
}

@end
