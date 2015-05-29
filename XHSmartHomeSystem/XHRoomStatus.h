//
//  XHRoomStatus.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/28/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHRoomStatus : NSObject

@property (nonatomic, assign) NSUInteger parlourStatus;
@property (nonatomic, assign) NSUInteger kitchenStatus;
@property (nonatomic, assign) NSUInteger bathroomStatus;
@property (nonatomic, assign) NSUInteger bedroomStatus;

+ (XHRoomStatus *)shareInstance; // singleton

@end
