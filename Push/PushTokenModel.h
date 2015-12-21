//
//  PushTokenModel.h
//  Push
//
//  Created by bruce on 15/12/15.
//  Copyright © 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>
//token的用户信息

@interface PushTokenModel : NSObject<NSCoding>

@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, strong) NSString *serverID;
@property(nonatomic, assign) NSInteger userID;
@property(nonatomic, assign) NSInteger gameID;

@end
