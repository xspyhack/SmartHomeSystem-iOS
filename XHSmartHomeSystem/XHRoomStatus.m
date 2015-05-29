//
//  XHRoomStatus.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/28/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomStatus.h"

@implementation XHRoomStatus

+ (XHRoomStatus *)shareInstance
{
    static XHRoomStatus *shareInstance = nil;
    static dispatch_once_t onceToken;
    // singleton
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
        shareInstance.parlourStatus = 0;
        shareInstance.kitchenStatus = 0;
        shareInstance.bathroomStatus = 0;
        shareInstance.bedroomStatus = 0;
    });
    
    return shareInstance;
}

@end
