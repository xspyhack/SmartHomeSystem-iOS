//
//  XHRoomTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomTools.h"
#import "XHRoomModel.h"
#import "XHDatabase.h"

@implementation XHRoomTools

+ (XHRoomModel *)roomModelWithString:(NSString *)aString
{
    XHRoomModel *roomModel = [[XHRoomModel alloc] init];
    if (aString) {
        NSArray *arrays = [aString componentsSeparatedByString:@";"];
        // don't forget aString is end with '\n',
        // looks like 00000001:SEN_TEMP:00000027;00000001:SEN_HUMI:00000040;/n
        // so arrays count is 3, we don't need the lastest.
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
        }
    }
    
    return roomModel;
}

+ (NSString *)stringWithString:(NSString *)aString
{
    if (aString) {
        return [NSString stringWithFormat:@"%.1f", [aString floatValue]];
    } else {
        return @":D";
    }
}

+ (NSArray *)recentWeekWithRoomId:(NSUInteger)roomId;
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %lu ORDER BY id LIMIT 0, 8", roomId];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSArray *)recentMonthWithRoomId:(NSUInteger)roomId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHRoom WHERE roomId = %lu ORDER BY id LIMIT 0, 30", roomId];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSArray *)recentYearWithRoomId:(NSUInteger)roomId
{
    NSString *sql = [NSString stringWithFormat:@"%lu", roomId];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSDictionary *)weekDataWithRoomId:(NSUInteger)roomId
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //NSArray *array = [self recentWeekWithRoomId:roomId];
    //dictionary[@"temperture"] = [self averageWithArray:array index:@"temperature"];
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

+ (CGFloat)averageWithArray:(NSArray *)array index:(NSString *)index
{
    float count;
    for (NSDictionary *dict in array) {
        count += [dict[index] floatValue];
    }
    
    return count / [array count];
}

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

@end
