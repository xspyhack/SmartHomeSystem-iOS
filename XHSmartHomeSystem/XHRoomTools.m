//
//  XHRoomTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomTools.h"
#import "XHRoomModel.h"
#import "XHRoomStatus.h"
#import "XHDatabase.h"
#import "NSDate+Utils.h"

@interface XHRoomTools ()
@property (nonatomic, assign) CGFloat temperatureAlertValue;
@property (nonatomic, assign) CGFloat humidityAlertValue;
@property (nonatomic, assign) CGFloat smokeAlertValue;
@property (nonatomic, assign) NSTimeInterval *timer;
@property (nonatomic, assign) XHRoomStatus *status;
@end;

@implementation XHRoomTools

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.temperatureAlertValue = [defaults floatForKey:@"XHTemperatureAlertValue"];
        self.humidityAlertValue = [defaults floatForKey:@"XHHumidityAlertValue"];
        self.smokeAlertValue = [defaults floatForKey:@"XHSmokeAlertValue"];
        self.status = [XHRoomStatus shareInstance];
    }
    return self;
}

- (NSArray *)roomModelWithString:(NSString *)aString
{
    NSMutableArray *roomModels = [NSMutableArray array];

    if (aString) {
        NSArray *arr = [self componentsSeparated:aString withLength:162];
        
        for (NSString *str in arr) {
            XHRoomModel *roomModel = [[XHRoomModel alloc] init];
            NSArray *arrays = [str componentsSeparatedByString:@";"];
            
            // the last array is blank, e.g. 1;1; is count 3.
            for (int i = 0; i < [arrays count] - 1; i++) {
                NSArray *array = [arrays[i] componentsSeparatedByString:@":"];
                NSString *Id = array[0];
                NSString *type = array[1];
                NSString *value = array[2];
                
                //NSString *preType = [type substringWithRange:NSMakeRange(0, 3)];
                //NSString *sufType = [type substringWithRange:NSMakeRange(4, 4)];
                NSString *preType = [type substringToIndex:3];
                NSString *sufType = [type substringFromIndex:4];
                
                roomModel.Id = [Id integerValue] - 1; // why? because Id is begin with 0, and some body is 1
                if ([preType isEqualToString:@"SEN"]) {
                    if ([sufType isEqualToString:@"TEMP"]) {
                        roomModel.temperature = [self stringWithString:value];
                    } else if ([sufType isEqualToString:@"HUMI"]) {
                        roomModel.humidity = [self stringWithString:value];
                    } else if ([sufType isEqualToString:@"SMOK"]) {
                        roomModel.smoke = [self stringWithString:value];
                    }
                    else { }
                } else if ([preType isEqualToString:@"LED"]) {
                    if ([sufType isEqualToString:@"TEMP"]) {
                        roomModel.temperatureStatus = [value isEqualToString:@"00000000"] ? NO : YES;
                    } else if ([sufType isEqualToString:@"HUMI"]) {
                        roomModel.humidityStatus = [value isEqualToString:@"00000000"] ? NO : YES;
                    } else if ([sufType isEqualToString:@"SMOK"]) {
                        roomModel.smokeStatus = [value isEqualToString:@"00000000"] ? NO : YES;
                    }
                    else { }
                }
                
                // check value
                if ([roomModel.temperature floatValue] >= self.temperatureAlertValue) {
                    [self pushLocalNotificationWithRoomId:roomModel.Id sensor:0 value:[roomModel.temperature floatValue]];
                }
                if ([roomModel.humidity floatValue] >= self.humidityAlertValue) {
                    [self pushLocalNotificationWithRoomId:roomModel.Id sensor:1 value:[roomModel.humidity floatValue]];
                }
                if ([roomModel.smoke floatValue] >= self.smokeAlertValue) {
                    [self pushLocalNotificationWithRoomId:roomModel.Id sensor:2 value:[roomModel.smoke floatValue]];
                }
            }
            [roomModels addObject:roomModel];
        }
    }
    
    return roomModels;
}

- (NSArray *)componentsSeparated:(NSString *)aString withLength:(NSInteger)length
{
    // don't forget aString is end with '\n',
    // looks like 00000001:SEN_TEMP:00000027;00000001:SEN_HUMI:00000040;\n
    // so we don't need the lastest.
    aString = [[aString componentsSeparatedByString:@"\n"] firstObject];
    
    length = length ? length : 162;
    //NSUInteger count = ([aString length] - 1) / length; // sub '\n'
    NSUInteger count = [aString length] / length;
    //count = count > 12 ? 12 : count;
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        NSString *str = [aString substringWithRange:NSMakeRange(length * i, length)];
        [array addObject:str];
    }
    return array;
}

- (NSString *)stringWithString:(NSString *)aString
{
    if (aString) {
        return [NSString stringWithFormat:@"%.1f", [aString floatValue]];
    } else {
        return @":D";
    }
}

#pragma mark - database operation

+ (NSArray *)recentWeekWithRoomId:(NSUInteger)roomId;
{
    NSInteger count = [self getCountWithRoomId:roomId];
    count = count > 8 ? count : 8;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %lu ORDER BY id LIMIT %ld, 8", (unsigned long)roomId, (count - 8)];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSArray *)recentMonthWithRoomId:(NSUInteger)roomId
{
    NSInteger count = [self getCountWithRoomId:roomId];
    count = count > 30 ? count : 30;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %lu ORDER BY id LIMIT %ld, 30", (unsigned long)roomId, (count - 30)];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSArray *)recentYearWithRoomId:(NSUInteger)roomId
{
    NSInteger count = [self getCountWithRoomId:roomId];
    count = count > 365 ? count : 365;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %lu ORDER BY id LIMIT %ld, 365", (unsigned long)roomId, (count - 365)];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSDictionary *)weekDataWithRoomId:(NSUInteger)roomId
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *array = [self recentWeekWithRoomId:roomId];
    dictionary[@"temperature_average"] = [NSString stringWithFormat:@"%.2f", [self averageWithArray:array index:@"temperature"]];
    dictionary[@"humidity_average"] = [NSString stringWithFormat:@"%.2f", [self averageWithArray:array index:@"humidity"]];
    dictionary[@"smoke_average"] = [NSString stringWithFormat:@"%.2f", [self averageWithArray:array index:@"smoke"]];
    
    dictionary[@"temperature_max"] = [NSString stringWithFormat:@"%.2f", [self maxWithArray:array index:@"temperature"]];
    dictionary[@"humidity_max"] = [NSString stringWithFormat:@"%.2f", [self maxWithArray:array index:@"humidity"]];
    dictionary[@"smoke_max"] = [NSString stringWithFormat:@"%.2f", [self maxWithArray:array index:@"smoke"]];
    
    dictionary[@"temperature_min"] = [NSString stringWithFormat:@"%.2f", [self minWithArray:array index:@"temperature"]];
    dictionary[@"humidity_min"] = [NSString stringWithFormat:@"%.2f", [self minWithArray:array index:@"humidity"]];
    dictionary[@"smoke_min"] = [NSString stringWithFormat:@"%.2f", [self minWithArray:array index:@"smoke"]];
    
    return dictionary;
}

+ (NSDictionary *)monthDataWithRoomId:(NSUInteger)roomId
{
    return nil;
}

+ (NSDictionary *)yearDataWithRoomId:(NSUInteger)roomId
{
    return nil;
}

+ (NSArray *)limitsDataWithRoomId:(NSUInteger)roomId
{
    XHDatabase *db = [[XHDatabase alloc] init];
    if (roomId > 3) {
        // min, average, max
        NSString *sql = @"SELECT MIN(temperature),AVG(temperature),MAX(temperature),MIN(humidity),AVG(humidity),MAX(humidity),MIN(smoke),AVG(smoke),MAX(smoke) FROM XHRoom";
        return [db executeQuery:sql];
    } else {
        NSString *sql = [NSString stringWithFormat:@"SELECT MIN(temperature),AVG(temperature),MAX(temperature),MIN(humidity),AVG(humidity),MAX(humidity),MIN(smoke),AVG(smoke),MAX(smoke) FROM XHRoom WHERE roomId = %ld", roomId];
        return [db executeQuery:sql];
    }
}

+ (NSUInteger)getCountWithRoomId:(NSUInteger)roomId
{
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM XHRoom WHERE roomId = %lu", roomId];
    return [db getCount:sql];
}

+ (CGFloat)averageWithArray:(NSArray *)array index:(NSString *)index
{
    float count = 0.0f;
    for (NSDictionary *dict in array) {
        count += [dict[index] floatValue];
    }
    
    return count / [array count];
}

// array: dictionary
+ (float)maxWithArray:(NSArray *)array index:(NSString *)index
{
    float max = -100.0f;
    for (NSDictionary *dict in array) {
        if (max < [dict[index] floatValue]) {
            max = [dict[index] floatValue];
        }
    }
    
    return max;
}

+ (float)minWithArray:(NSArray *)array index:(NSString *)index
{
    float min = 100.0f;
    for (NSDictionary *dict in array) {
        if (min > [dict[index] floatValue]) {
            min = [dict[index] floatValue];
        }
    }
    
    return min;
}

+ (NSArray *)sort:(NSArray *)array
{
    return nil;
}

+ (BOOL)saveIfIsFirstDataOfToday:(XHRoomModel *)model
{
    // read the lastest data from database
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %ld ORDER BY id DESC LIMIT 0, 1", (long)model.Id];
    NSArray *array = [db executeQuery:sql];
    NSDictionary *dict = [NSDictionary dictionary];
    dict = array.lastObject;
    NSString *date = dict[@"date"];
    
    NSString *today = [NSDate stringYearMonthDayWithDate:nil];
    if (![date isEqualToString:today]) {
        // save to database
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO XHRoom('roomId', 'roomName', 'temperature', 'humidity', 'smoke', 'date') VALUES(%ld, '%@', '%@', '%@', '%@', '%@')",
                         (long)model.Id,
                         model.name,
                         model.temperature,
                         model.humidity,
                         model.smoke,
                         today];
        [db executeNonQuery:sql];
        XHLog(@"save first data, id: %ld", model.Id);
        return YES;
    }
    return NO;
}

#pragma mark - notificaton

- (void)pushLocalNotificationWithRoomId:(NSUInteger)roomId sensor:(NSUInteger)index value:(CGFloat)value
{
    NSString *sensor = @"";
    switch (index) {
        case 0:
            if ([self checkTemperatureStatusWithId:roomId]) return;
            sensor = NSLocalizedString(@"temperature", nil);
            break;
        case 1:
            if ([self checkHumidityStatusWithId:roomId]) return;
            sensor = NSLocalizedString(@"humidity", nil);
            break;
        case 2:
            if ([self checkSmokeStatusWithId:roomId]) return;
            sensor = NSLocalizedString(@"smoke", nil);
            break;
        default:
            break;
    }
    
    NSString *roomName = [self getRoomNameWithId:roomId];
    if (!roomName) {
        return;
    }
    
    NSString *alertBody = [NSString stringWithFormat:NSLocalizedString(@"My master, %@'s %@ now %.2f!", nil), NSLocalizedString(roomName, nil), sensor, value];
    
    // push update message notification
    [[NSNotificationCenter defaultCenter] postNotificationName:XHDidAlertNotification
                                                        object:nil
                                                      userInfo:@{ @"strName" : roomName, @"strContent" : alertBody }];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationEnabled"] isEqualToString:@"Disabled"]) {
        return;
    }
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    if (![defaluts boolForKey:@"XHTemperatureAlertor"] && [sensor isEqualToString:@"temperature"]) {
        return;
    }
    if (![defaluts boolForKey:@"XHHumidityAlertor"] && [sensor isEqualToString:@"humidity"]) {
        return;
    }
    if (![defaluts boolForKey:@"XHSmokeAlertor"] && [sensor isEqualToString:@"smoke"]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // define local notification object
        NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
        notification.repeatInterval = 2;
        notification.alertBody = alertBody;
        notification.applicationIconBadgeNumber = number + 1;
        notification.alertAction = @"open";
        notification.alertLaunchImage = @"1";
        notification.soundName = @"msg.caf";
        notification.userInfo = @{ @"id" : @1, @"user" : @"b233" };
        [[UIApplication sharedApplication] scheduleLocalNotification:notification]; // local notification
    });
}

- (NSString *)getRoomNameWithId:(NSUInteger)Id
{
    NSString *name = @"";
    switch (Id) {
        case XHParlour:
            name = @"parlour";
            break;
        case XHKitchen:
            name = @"kitchen";
            break;
        case XHBathroom:
            name = @"bathroom";
            break;
        case XHBedroom:
            name = @"bedroom";
            break;
        default:
            name = nil;
            break;
    }
    return name;
}

// return:
- (BOOL)checkTemperatureStatusWithId:(NSUInteger)Id
{
    switch (Id) {
        case XHParlour:
            if ((self.status.parlourStatus & 1) == 1) return YES;
            else self.status.parlourStatus += 1;
            break;
        case XHKitchen:
            if ((self.status.kitchenStatus & 1) == 1) return YES;
            else self.status.kitchenStatus += 1;
            break;
        case XHBathroom:
            if ((self.status.bathroomStatus & 1) == 1) return YES;
            else self.status.bathroomStatus += 1;
            break;
        case XHBedroom:
            if ((self.status.bedroomStatus & 1) == 1) return YES;
            else self.status.bedroomStatus += 1;
            break;
        default:
            break;
    }
    return NO;
}

- (BOOL)checkHumidityStatusWithId:(NSUInteger)Id
{
    switch (Id) {
        case XHParlour:
            if ((self.status.parlourStatus & 2) == 2) return YES;
            else self.status.parlourStatus += 2;
            break;
        case XHKitchen:
            if ((self.status.kitchenStatus & 2) == 2) return YES;
            else self.status.kitchenStatus += 2;
            break;
        case XHBathroom:
            if ((self.status.bathroomStatus & 2) == 2) return YES;
            else self.status.bathroomStatus += 2;
            break;
        case XHBedroom:
            if ((self.status.bedroomStatus & 2) == 2) return YES;
            else self.status.bedroomStatus += 2;
            break;
        default:
            break;
    }
    return NO;
}

- (BOOL)checkSmokeStatusWithId:(NSUInteger)Id
{
    switch (Id) {
        case XHParlour:
            if ((self.status.parlourStatus & 4) == 4) return YES;
            else self.status.parlourStatus += 4;
            break;
        case XHKitchen:
            if ((self.status.kitchenStatus & 4) == 4) return YES;
            else self.status.kitchenStatus += 4;
            break;
        case XHBathroom:
            if ((self.status.bathroomStatus & 4) == 4) return YES;
            else self.status.bathroomStatus += 4;
            break;
        case XHBedroom:
            if ((self.status.bedroomStatus & 4) == 4) return YES;
            else self.status.bedroomStatus += 4;
            break;
        default:
            break;
    }
    return NO;
}

@end
