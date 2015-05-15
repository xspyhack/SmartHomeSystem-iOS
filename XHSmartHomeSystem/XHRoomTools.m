//
//  XHRoomTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomTools.h"
#import "XHRoomModel.h"

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

@end
