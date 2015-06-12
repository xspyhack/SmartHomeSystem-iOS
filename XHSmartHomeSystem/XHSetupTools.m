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
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO XHRoom('roomId', 'roomName', 'temperature', 'humidity', 'smoke', 'date') VALUES(%d, '%d', '%d', '%d', '%d', '%@')", i, i, 10+i*j, i*j+30, i*j+15, [NSDate stringYearMonthDayWithDate:[NSDate dateYesterday]]];
                [db executeNonQuery:sql];
                XHLog(@"%@", sql);

                sql = [NSString stringWithFormat:@"INSERT INTO XHMessage('strId', 'strName', 'strIcon', 'strContent', 'strTime') VALUES(%d, 'Hey,%d', 'headImage', '%d %d %@', '%@')", i, j, i, j,[self getRandomString], [[NSDate date] description]];
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
    
    [defaults setInteger:0 forKey:@"XHThemeColor"];
    
    // display
    [defaults setBool:YES forKey:@"XHChartMode"];
    [defaults setBool:YES forKey:@"XHGaugeMode"];
    [defaults setBool:NO forKey:@"XHCmdLineMode"];
    [defaults setFloat:1.0f forKey:@"XHLineWidth"];
    
    // color
    [defaults setInteger:4 forKey:@"XHTemperatureColor"];
    [defaults setInteger:13 forKey:@"XHHumidityColor"];
    [defaults setInteger:18 forKey:@"XHSmokeColor"];
    
    // values
    [defaults setFloat:60.0f forKey:@"XHTemperatureMaxValue"];
    [defaults setFloat:-40.0f forKey:@"XHTemperatureMinValue"];
    [defaults setFloat:40.0f forKey:@"XHHumidityMinValue"];
    [defaults setFloat:60.0f forKey:@"XHHumidityMaxValue"];
    [defaults setFloat:0.0f forKey:@"XHSmokeMinValue"];
    [defaults setFloat:30.0f forKey:@"XHSmokeMaxValue"];
    
    // language
    [defaults setInteger:0 forKey:@"XHLanguage"];
    
    // notification
    [defaults setBool:YES forKey:@"XHShowPreviewText"];
    [defaults setBool:YES forKey:@"XHTemperatureAlertor"];
    [defaults setBool:NO forKey:@"XHHumidityAlertor"];
    [defaults setBool:YES forKey:@"XHSmokeAlertor"];
    // alert values
    [defaults setFloat:35.0f forKey:@"XHTemperatureAlertValue"];
    [defaults setFloat:60.0f forKey:@"XHHumidityAlertValue"];
    [defaults setFloat:10.0f forKey:@"XHSmokeAlertValue"];
    [defaults setInteger:0 forKey:@"XHMessageType"];
    // alert time
    [defaults setObject:@"9:00" forKey:@"XHNotificationStartTime"];
    [defaults setObject:@"23:00" forKey:@"XHNotificationEndTime"];
    
    // security
    [defaults setBool:YES forKey:@"XHCheckIn"];
    [defaults setInteger:1 forKey:@"XHEncryptType"];
    
    // is first time use this app
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
