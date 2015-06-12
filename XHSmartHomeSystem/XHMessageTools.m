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

+ (NSArray *)latestMessagesWithNumber:(NSUInteger)number
{
    return [self latestMessagesFrom:0 number:number];
}

+ (NSArray *)latestMessagesWithNumber:(NSUInteger)number userName:(NSString *)userName
{
    NSInteger count = [self messagesCountWithUserName:userName];
    count = count > number ? count : number;
    
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage WHERE strName = '%@' ORDER BY id DESC LIMIT 0, %lu", userName, number];
    return [db executeQuery:sql];
}

+ (NSArray *)latestMessagesFrom:(NSUInteger)from number:(NSUInteger)number
{
    NSInteger count = [self messagesCountWithUserName:nil];
    if (from >= count) {
        return nil;
    }
    count = count > (number + from) ? count : (number + from);
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage ORDER BY id LIMIT %lu, %lu", (count - from - number), number];
    return [db executeQuery:sql];
}

+ (NSArray *)messagesAtIndexes:(NSIndexSet *)indexes
{
    //NSInteger count = [self messagesCountWithUserName:nil];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage WHERE id BETWEEN %ld AND %ld", indexes.firstIndex, indexes.lastIndex];
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db executeQuery:sql];
}

+ (NSInteger)messagesCountWithUserName:(NSString *)userName
{
    NSString *sql = @"";
    if (userName) {
        sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM XHMessage WHERE strName = '%@'", userName];
    } else {
        sql = @"SELECT COUNT(*) FROM XHMessage";
    }
    XHDatabase *db = [[XHDatabase alloc] init];
    return [db getCount:sql];
}

+ (void)saveMessages:(NSDictionary *)dictionary
{
    if (dictionary) {
        XHDatabase *db = [[XHDatabase alloc] init];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO XHMessage('strId', 'strName', 'strIcon', 'strContent', 'strTime') VALUES(1, '%@', '%@',\"%@\", '%@')", dictionary[@"strName"], dictionary[@"strIcon"], dictionary[@"strContent"], dictionary[@"strTime"]];
        [db executeNonQuery:sql];
    }
}

+ (NSArray *)messages
{
    XHDatabase *db = [[XHDatabase alloc] init];
    NSString *sql = @"SELECT * FROM XHMessage";
    return [db executeQuery:sql];
}

+ (NSArray *)messagesWithSearchString:(NSString *)searchString
{
    if (searchString) {
        XHDatabase *db = [[XHDatabase alloc] init];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM XHMessage WHERE strContent like '%%%@%%'", searchString];
        return [db executeQuery:sql];
    }
    return [self messages];
}

+ (void)removeMessagesWithUserName:(NSString *)userName
{
    if (userName) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM XHMessage WHERE strName = '%@'", userName];
        XHDatabase *db = [[XHDatabase alloc] init];
        [db executeNonQuery:sql];
    } else {
        [self removeMessages];
    }
}

+ (void)removeMessages
{
    NSString *sql = @"DELETE FROM XHMessage";
    XHDatabase *db = [[XHDatabase alloc] init];
    [db executeNonQuery:sql];
}

@end
