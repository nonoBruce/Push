//
//  PushTokenModel.h
//  Push
//
//  Created by bruce on 15/12/15.
//  Copyright © 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushTokenModel : NSObject<NSCoding>

@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, assign) NSInteger userID;
@property(nonatomic, assign) NSInteger gameID;
@property(nonatomic, strong) NSString *serverID;

@end
