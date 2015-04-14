//
//  XHHomeDataModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHHomeDataModel.h"

@implementation XHHomeDataModel

- (NSString *)temperature
{
    return [NSString stringWithFormat:@"temp: %@°C", _temperature];
}

- (NSString *)humidity
{
    return [NSString stringWithFormat:@"humi: %@%%RH", _humidity];
}

@end
