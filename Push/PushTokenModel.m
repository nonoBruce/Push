//
//  PushTokenModel.m
//  Push
//
//  Created by bruce on 15/12/15.
//  Copyright © 2015年 KY. All rights reserved.
//

#import "PushTokenModel.h"

@implementation PushTokenModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeInteger:self.userID forKey:@"userID"];
    [aCoder encodeInteger:self.gameID forKey:@"gameID"];
    [aCoder encodeObject:self.serverID forKey:@"serverID"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.userID = [aDecoder decodeIntegerForKey:@"userID"];
        self.gameID = [aDecoder decodeIntegerForKey:@"gameID"];
        self.serverID = [aDecoder decodeObjectForKey:@"serverID"];
    }
    return self;
}
@end
