//
//  KYPushManager.h
//  Push
//
//  Created by bruce on 15/12/16.
//  Copyright © 2015年 KY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYPushManager : NSObject

+ (KYPushManager *)shareInstance;


- (void)setupWithApplication:(UIApplication *)application andOption:(NSDictionary *)launchingOption;

// upload device token
- (void)registerDeviceToken:(NSData *)deviceToken;

// receive notification recieved
- (void)receiveRemoteNotification:(NSDictionary *)remoteInfo;

// register notification type
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;


#pragma mark - localNotification

- (void)receiveLocalNotification:(NSDictionary *)localInfo;

- (void)localNotificationOne;
@end
