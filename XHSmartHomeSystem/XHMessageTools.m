//
//  XHMessageTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessageTools.h"
#import "XHDatabase.h"

@implementation XHMessageTools

+ (NSArray *)latestMessageWithNumber:(NSUInteger)number
{
    NSInteger count = [self getCountWithNumber:nil];
    count = count > number ? count : number;
    
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage ORDER BY id LIMIT %ld, %lu", (count - number), number];
    return [db executeQuery:sql];
}

+ (NSArray *)latestMessageWithNumber:(NSUInteger)number userName:(NSString *)userName
{
    NSInteger count = [self getCountWithNumber:userName];
    count = count > number ? count : number;
    
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage WHERE strName = '%@' ORDER BY id DESC LIMIT 0, %lu", userName, number];
    return [db executeQuery:sql];
}

+ (NSInteger)getCountWithNumber:(NSString *)userName
{
    if (userName) {
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM XHMessage WHERE strName = '%@'", userName];
        XHDatabase *db = [[XHDatabase alloc] init];
        return [db getCount:sql];
    } else {
        NSString *sql = @"SELECT COUNT(*) FROM XHMessage";
        XHDatabase *db = [[XHDatabase alloc] init];
        return [db getCount:sql];
    }
}

@end
