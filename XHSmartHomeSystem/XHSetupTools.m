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
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO XHRoom('roomId', 'roomName', 'temperature', 'humidity', 'smoke') VALUES(%d, '%d', '%d', '%d', '%d')", i, i, 10+i*j, i*j+1, i*j+1];
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

@end
