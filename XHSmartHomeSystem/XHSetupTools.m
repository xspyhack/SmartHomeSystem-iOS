//
//  XHSetupTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/5/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSetupTools.h"
#import "XHCryptTools.h"
#import "XHDatabase.h"
#import "NSDate+Utils.h"

@implementation XHSetupTools

+ (void)check
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *xh = [defaults objectForKey:@"XH"];
    
    if (!xh) {
        //
        XHDatabase *db = [[XHDatabase alloc] init];
        [db createTable];
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 10; j++) {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO XHRoom('roomId', 'roomName', 'temperature', 'humidity', 'smoke', 'date') VALUES(%d, '%d', '%d', '%d', '%d', '%@')", i, i, 10+i*j, i*j+1, i*j+1, [NSDate stringYearMonthDayWithDate:[NSDate dateYesterday]]];
                [db executeNonQuery:sql];
                XHLog(@"%@", sql);

                sql = [NSString stringWithFormat:@"INSERT INTO XHMessage('strId', 'strName', 'strIcon', 'strContent', 'strTime') VALUES(%d, 'Hey,%d', 'headImage', '%@', '%@')", i, j, [self getRandomString], [[NSDate date] description]];
                [db executeNonQuery:sql];
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self setUserDefaults];
        });
    }

}

+ (void)setUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:12345 forKey:@"XHPort"];
    [defaults setObject:[XHCryptTools md5WithKey:@"admin"] forKey:@"XHPassword"];
    [defaults setFloat:60.0f forKey:@"XHTemperatureMaxValue"];
    [defaults setFloat:-40.0f forKey:@"XHTemperatureMinValue"];
    
    [defaults setFloat:40.0f forKey:@"XHHumidityMinValue"];
    [defaults setFloat:60.0f forKey:@"XHHumidityMaxValue"];
    
    [defaults setFloat:20.0f forKey:@"XHSmokeMinValue"];
    [defaults setFloat:60.0f forKey:@"XHSmokeMaxValue"];
    
    [defaults setFloat:1.0f forKey:@"XHLineWidth"];
    
    [defaults setObject:@"XH" forKey:@"XH"];
}

+ (NSString *)getRandomString {
    
    NSString *lorumIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales.";
    
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
    
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(6, r); // no less than 6 words
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}

@end
