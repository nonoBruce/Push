//
//  KYPushManager.m
//  Push
//
//  Created by bruce on 15/12/16.
//  Copyright © 2015年 KY. All rights reserved.
//

#define  NOTIFICATIONUSERDEFAULT   @"NOTIFICATIONUSERDEFAULT"
#define  SENDDEVICETOKENURL        @"http://172.16.230.164/shop/index.php/PushService/PushUserInfo/tokenDevice"


#import "KYPushManager.h"
#import "KYUserDefault.h"

@interface KYPushManager()
@property(nonatomic, strong) UIApplication *application;

@end


@implementation KYPushManager

+ (KYPushManager *)shareInstance {
    
    static KYPushManager *mInstance = nil;
    static dispatch_once_t onceTokenKYPushManager;
    dispatch_once(&onceTokenKYPushManager, ^{
        mInstance = [[[self class] alloc] init];
    });
    return mInstance;
}

#pragma mark - push

- (void)setupWithApplication:(UIApplication *)application andOption:(NSDictionary *)launchingOption {
    self.application = application;
    [self initPushManager:application];
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber >0){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}

- (void)initPushManager:(UIApplication *)application{
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings * settingsAvailable = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settingsAvailable];
        [application registerForRemoteNotifications];
        
    }else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kyActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:application];
}

- (void)kyActive:(UIApplication *)application{
    if([UIApplication sharedApplication].applicationIconBadgeNumber >0){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}

// upload device token
- (void)registerDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    
    NSCharacterSet* cs = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
    NSString *tokenString = [[token componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSLog(@"%@", tokenString);
    
    //判断token是否需要更新
    //是否需要更新判断--1、本地是否保存过了 没有保存直接发送  2、本地是否更新了，更新了直接发送
    //每次都发送？本地更新包括gameid，userid，serviceid，devicetoken
    //每次选择完服务器后判断是否需要更新一devicetoken作为key值更新
    //发送tokenString、SDK中、可以把token存起来，在选择服务器后再提交数据
    //gameID,userID,serverID,deviceToken
    
    PushTokenModel *currentTokenModel = [[PushTokenModel alloc] init];
    currentTokenModel.deviceToken = tokenString;
    currentTokenModel.gameID = 1;
    currentTokenModel.userID = 10086;
    currentTokenModel.serverID = @"1";
    
    if(![[KYUserDefault shareInstance] isSame:currentTokenModel]){//不相同的时候替换
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%zd",currentTokenModel.gameID] forKey:@"gameID"];
        [dic setObject:[NSString stringWithFormat:@"%zd",currentTokenModel.userID] forKey:@"userID"];
        [dic setObject:currentTokenModel.serverID forKey:@"serverID"];
        [dic setObject:currentTokenModel.deviceToken forKey:@"deviceToken"];
        
        [self sendDeviceToken:dic];
    }else{
        NSLog(@"saved");
    }
    
}


// register notification type
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types {
    
}

//- (void)re

// handle notification recieved
- (void)receiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    // 默认设置为0
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    NSLog(@"userinfo:%@",userInfo);
    NSDictionary *dic = [userInfo objectForKey:@"aps"];
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    NSString *title = [dic objectForKey:@"title"];
    NSString *message = [dic objectForKey:@"alert"];
    NSString *ensure = [dic objectForKey:@"ensure"];
    NSString *cancel = [dic objectForKey:@"cancel"];
    if(title && ensure.length ==0){
        title = nil;
    }
    if(ensure && ensure.length ==0){
        ensure = nil;
    }
    if(cancel && cancel.length ==0){
        cancel = nil;
    }
    
    NSNumber *num = [dic objectForKey:@"isShow"];
    
    if(num.intValue==0){
        return;
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:ensure, nil];
    [alertview show];
    
    

//    if (self.application.applicationState == UIApplicationStateActive) {
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.userInfo = userInfo;
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        
//        localNotification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
//        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5.0];
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    }
//    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
//    else if (self.application.applicationState == UIApplicationStateInactive){
//        //......
//    }
}


- (void)sendDeviceToken:(NSDictionary *)dic{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:SENDDEVICETOKENURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSLog(@"%@",error);
            return ;
        }
        
        NSError *resultError;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&resultError];
        
        NSLog(@"%@",resultDic);
    }];
    [postDataTask resume];
}


#pragma mark - localNotification

- (void)receiveLocalNotification:(NSDictionary *)localInfo{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"welcome" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"receive local notification");
}

- (void)localNotificationOne{
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:5.0];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        // 设置提醒的文字内容
        notification.alertBody   = @"Wake up, man";
        notification.alertAction = NSLocalizedString(@"起床了", nil);
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        // 设置应用程序右上角的提醒个数
        notification.applicationIconBadgeNumber++;
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
//        aUserInfo[kLocalNotificationID] = @"LocalNotificationID";
        notification.userInfo = aUserInfo;
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end