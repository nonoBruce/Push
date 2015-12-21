//
//  KYPushManager.m
//  Push
//
//  Created by bruce on 15/12/16.
//  Copyright © 2015年 KY. All rights reserved.
//

#define  NOTIFICATIONUSERDEFAULT   @"NOTIFICATIONUSERDEFAULT"
#define  SENDDEVICETOKENURL        @"http://172.16.230.165/shop/index.php/PushService/PushUserInfo/tokenDevice"


#import "KYPushManager.h"
#import "KYUserDefault.h"

@interface KYPushManager()<UIAlertViewDelegate>
@property(nonatomic, strong) UIApplication *application;

@end

NSString *const KYHASNOTIFICATION               = @"KYHASNOTIFICATION";
NSString *const KYPUSHNOTIFICATION              = @"KYPUSHNOTIFICATION";


@implementation KYPushManager


+ (KYPushManager *)shareInstance {
    
    static KYPushManager *mInstance = nil;
    static dispatch_once_t onceTokenKYPushManager;
    dispatch_once(&onceTokenKYPushManager, ^{
        mInstance = [[[self class] alloc] init];
    });
    return mInstance;
}

- (instancetype)init{
    if(self = [super init]){
    }
    
    return self;
}

#pragma mark - push

- (void)setupWithApplication:(UIApplication *)application andOption:(NSDictionary *)launchingOption {
    self.application = application;
    [self initPushManager:application];
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
        [[KYUserDefault shareInstance] saveHasNoticeToDefault:YES];
    }
    self.hasNotice = [[KYUserDefault shareInstance] getHasNoticeFromDefault] ;
    
    if(self.hasNotice){
        //push notification -> has notification
        [[NSNotificationCenter defaultCenter] postNotificationName:KYHASNOTIFICATION object:nil];
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

// handle notification recieved
- (void)receiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    // 默认设置为0
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
//    NSLog(@"userinfo:%@",userInfo);
//    NSDictionary *dic = [userInfo objectForKey:@"aps"];
//    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    
//    NSString *title = [dic objectForKey:@"title"];
//    NSString *message = [dic objectForKey:@"alert"];
//    NSString *ensure = [dic objectForKey:@"ensure"];
//    NSString *cancel = [dic objectForKey:@"cancel"];
//    if(title && ensure.length ==0){
//        title = nil;
//    }
//    if(ensure && ensure.length ==0){
//        ensure = nil;
//    }
//    if(cancel && cancel.length ==0){
//        cancel = nil;
//    }
//    
//    NSNumber *num = [dic objectForKey:@"isShow"];
//    
//    if(num.intValue==0){
//        return;
//    }
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:ensure, nil];
//    alertview.tag = 1002;
//    [alertview show];
    
    

    if (self.application.applicationState == UIApplicationStateActive) {
        //修改图标-》红点显示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Welcome!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancle", nil];
        alert.tag = 1001;
        [alert show];
        NSLog(@"UIApplicationStateActive");
    }
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    else if (self.application.applicationState == UIApplicationStateInactive){
        //修改图标-》红点显示
        
        NSLog(@"UIApplicationStateActive");
        [[NSNotificationCenter defaultCenter] postNotificationName:KYPUSHNOTIFICATION object:nil];

    }
    else if (self.application.applicationState == UIApplicationStateBackground){
        //修改图标-》红点显示
        
        NSLog(@"UIApplicationStateActive");
//        [[NSNotificationCenter defaultCenter] postNotificationName:KYPUSHNOTIFICATION object:nil];

    }
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
    if (self.application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Welcome!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancle", nil];
        alert.tag = 1001;
        [alert show];
        
        NSLog(@"receive local notification");
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KYPUSHNOTIFICATION object:nil];

    }
    
}

- (void)localNotificationOne{
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:5.0];
//        notification.repeatInterval = kCFCalendarUnitDay;        // 设置重复间隔
        notification.alertBody   = @"come on ";        // 设置提醒的文字内容
        notification.alertAction = NSLocalizedString(@"will", nil);
        notification.soundName= UILocalNotificationDefaultSoundName;// 通知提示音 使用默认的
        notification.applicationIconBadgeNumber++;// 设置应用程序右上角的提醒个数
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];// 设定通知的userInfo，用来标识该通知
//        aUserInfo[kLocalNotificationID] = @"LocalNotificationID";
        notification.userInfo = aUserInfo;
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - Notification Handle
- (void)isRead {
    [[KYUserDefault shareInstance] saveHasNoticeToDefault:NO];
    self.hasNotice = NO;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark - delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1001:{//本地通知
            switch (buttonIndex) {
                case 0:{//跳转
                    //has notification -> jump to  notification viewController
                    [[NSNotificationCenter defaultCenter] postNotificationName:KYPUSHNOTIFICATION object:nil];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1002:{//本地通知
            switch (buttonIndex) {
                case 0:{//跳转
                    //has notification -> jump to  notification viewController
                    [[NSNotificationCenter defaultCenter] postNotificationName:KYPUSHNOTIFICATION object:nil];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
@end
