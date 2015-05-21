//
//  XHDatabase.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHDatabase.h"
#import "FMDB.h"

@interface XHDatabase ()

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation XHDatabase

- (void)createTable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.dbPath]) {
        NSString *sql = @"CREATE TABLE 'XHRoom' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'roomId' INTEGER, 'roomName' VARCHAR(20), 'temperature' VARCHAR(10), 'humidity' VARCHAR(10), 'smoke' VARCHAR(10), 'date' DATE)";
        [self executeNonQuery:sql];
        
        sql = @"CREATE TABLE 'XHMessage' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'strId' INTEGER, 'strName' VARCHAR(20), 'strIcon' VARCHAR(200), 'strContent' VARCHAR(10), 'strTime' DATETIME)";
        [self executeNonQuery:sql];
    }
}

- (BOOL)open
{
    if (!self.database) {
        self.database = [FMDatabase databaseWithPath:self.dbPath];
    }
    
    if ([self.database open]) {
        return YES;
    } else {
        XHLog(@"Open database failed");
        return NO;
    }
}

- (void)close
{
    [self.database close];
}

- (void)executeNonQuery:(NSString *)sql
{
    // insert, update, delete
    if ([self open]) {
        if (![self.database executeUpdate:sql]) {
            XHLog(@"Error when execute %@", sql);
        }
        [self close];
    } else {
        XHLog(@"Open database failed.");
    }
    
}

- (NSArray *)executeQuery:(NSString *)sql
{
    if ([self open]) {
        NSMutableArray *arrays = [NSMutableArray array];
        FMResultSet *results = [self.database executeQuery:sql];
        while (results.next) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i < results.columnCount; i++) {
                dictionary[[results columnNameForIndex:i]] = [results stringForColumnIndex:i];
            }
            [arrays addObject:dictionary];
        }
        [self close];
        return arrays;
    } else {
        XHLog(@"Open database failed.");
        return nil;
    }
}

- (NSInteger)getCount:(NSString *)sql
{
    int count = 0;
    if ([self open]) {
        FMResultSet *results = [self.database executeQuery:sql];
        if ([results next]) {
            count = [results intForColumnIndex:0];
        }
        [self close];
    } else {
        XHLog(@"Open database failed.");
    }
    return count;
}

- (NSString *)dbPath
{
    if (!_dbPath) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
        self.dbPath = [doc stringByAppendingString:@"xhsmarthomesystem.db"];
    }
    return _dbPath;
}

@end
