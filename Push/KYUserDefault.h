//
//  KYUserDefault.h
//  KYUserDefault
//
//  Created by bruce on 15/12/15.
//  Copyright © 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushTokenModel.h"
//目的是判断本地的deviceToken是否发生了变化，如果变化了，就上传新的deviceToken替换服务器上旧的token

extern NSString * const KYNOTIFICATIONDEFAULT;

@interface KYUserDefault : NSObject

+ (KYUserDefault *)shareInstance;

- (void)setDefault;

- (void)initUserDefaults:(NSDictionary *)dic;


#pragma mark - DeviceToken

- (BOOL)isSame:(PushTokenModel *)tokenModel;

- (void)saveDeviceModelToDefault:(PushTokenModel *)tokenModel;

- (PushTokenModel *)getDeviceModelFromDefault;

- (void)deleteDeviceModelDefault;

@end
