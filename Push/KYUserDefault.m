//
//  KYUserDefault.m
//  KYUserDefault
//
//  Created by bruce on 15/12/15.
//  Copyright © 2015年 KY. All rights reserved.
//

#import "KYUserDefault.h"


NSString *const KYNOTIFICATIONDEFAULT  = @"KYNOTIFICATIONDEFAULT";


@implementation KYUserDefault


+ (KYUserDefault *)shareInstance {
    static KYUserDefault *mInstance = nil;
    static dispatch_once_t onceTokenKYUserDefault;
    dispatch_once(&onceTokenKYUserDefault, ^{
        mInstance = [[[self class] alloc] init];
    });
    return mInstance;
}

- (void)setDefault{
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"bruce",KYUSERNAMEDEFAULTS, nil];
//    [self initUserDefaults:dic];
}

- (void)initUserDefaults:(NSDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
}


#pragma mark - DeviceToken
//判断token的内容是否相同
- (BOOL)isSame:(PushTokenModel *)tokenModel{
    PushTokenModel *model = [self getDeviceModelFromDefault];
    if(model){
        if([model.deviceToken isEqualToString:tokenModel.deviceToken] &&
           model.userID == tokenModel.userID &&
           model.gameID == tokenModel.gameID &&
           [model.serverID isEqualToString:tokenModel.serverID]){
            
            return YES;
        }
    }
    //不同则保存
    [self saveDeviceModelToDefault:tokenModel];
    
    return NO;
    
}

- (void)saveDeviceModelToDefault:(PushTokenModel *)tokenModel{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tokenModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KYNOTIFICATIONDEFAULT];
}

- (PushTokenModel *)getDeviceModelFromDefault{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KYNOTIFICATIONDEFAULT];
    PushTokenModel *deviceModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return deviceModel;
}

- (void)deleteDeviceModelDefault{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KYNOTIFICATIONDEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
