//
//  XHRoomModel.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHRoomModel : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *smoke;
@property (nonatomic, assign) BOOL temperatureStatus; // status ? on : off
@property (nonatomic, assign) BOOL humidityStatus;
@property (nonatomic, assign) BOOL smokeStatus;

+ (instancetype)roomModelWithDictionary:(NSDictionary *)dictionary;
- (XHRoomModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
