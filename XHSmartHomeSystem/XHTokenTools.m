//
//  XHTokenTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTokenTools.h"
#import "XHTokenModel.h"

#define XHTokenFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"token.data"]

@implementation XHTokenTools

+ (void)save:(XHTokenModel *)tokenModel
{
    // use archiver
    [NSKeyedArchiver archiveRootObject:tokenModel toFile:XHTokenFilePath];
}

+ (void)remove:(XHTokenModel *)tokenModel
{
    tokenModel.expires_time = [NSDate distantPast];
    [NSKeyedArchiver archiveRootObject:tokenModel toFile:XHTokenFilePath];
}

+ (XHTokenModel *)tokenModel
{
    XHTokenModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:XHTokenFilePath];
    NSDate *now = [NSDate date];
    
    // expiration time
    if ([now compare:model.expires_time] == NSOrderedDescending) {
        model = nil;
    }
    return model;
}

@end
