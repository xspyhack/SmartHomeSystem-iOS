//
//  XHRoomModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomModel.h"

@implementation XHRoomModel

+ (instancetype)roomModelWithDict:(NSDictionary *)dict
{
    XHRoomModel *roomModel = [[XHRoomModel alloc] initWithDict:dict];
    return roomModel;
}

- (XHRoomModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.Id = [dict[@"Id"] integerValue];
        self.iconName = dict[@"iconName"];
        self.name = dict[@"name"];
        self.temperature = dict[@"temperature"];
        self.humidity = dict[@"humidity"];
    }
    
    return self;
}

- (NSString *)temperature
{
    return [NSString stringWithFormat:@"temp: %@°C", _temperature];
}

- (NSString *)humidity
{
    return [NSString stringWithFormat:@"humi: %@%%RH", _humidity];
}

@end
