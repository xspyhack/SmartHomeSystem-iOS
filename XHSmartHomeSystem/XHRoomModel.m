//
//  XHRoomModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomModel.h"

@implementation XHRoomModel

+ (instancetype)roomModelWithDictionary:(NSDictionary *)dictionary
{
    XHRoomModel *roomModel = [[XHRoomModel alloc] initWithDictionary:dictionary];
    return roomModel;
}

- (XHRoomModel *)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.Id = [dictionary[@"Id"] integerValue];
        self.iconName = dictionary[@"iconName"];
        self.name = dictionary[@"name"];
        self.temperature = dictionary[@"temperature"];
        self.humidity = dictionary[@"humidity"];
        self.smoke = dictionary[@"smoke"];
        self.temperatureStatus = [dictionary[@"temperatureStatus"] boolValue];
        self.humidityStatus = [dictionary[@"humidityStatus"] boolValue];
        self.smokeStatus = [dictionary[@"smokeStatus"] boolValue];
        
        [self setValuesForKeysWithDictionary:dictionary]; // use KVC
    }
    
    return self;
}

//- (NSString *)temperature
//{
//    if (!_temperature) {
//        _temperature = [NSString stringWithFormat:@"temp: %@°C", _temperature];
//    }
//    
//    return _temperature;
//}

//- (void)setTemperature:(NSString *)temperature
//{
//    _temperature = [NSString stringWithFormat:@"temp: %@°C", temperature];
//}

//- (NSString *)humidity
//{
//    if (!_humidity) {
//        _humidity = [NSString stringWithFormat:@"humi: %@%%RH", _humidity];
//    }
//    
//    return _humidity;
//}

//- (void)setHumidity:(NSString *)humidity
//{
//    _humidity = [NSString stringWithFormat:@"humi: %@%%RH", humidity];
//}

@end
