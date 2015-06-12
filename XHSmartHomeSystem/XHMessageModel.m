//
//  XHMessageModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/14/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessageModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "XHMessageTools.h"

@implementation XHMessageModel

- (void)populateDataSource
{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:[self getMessagesFromDBFrom:0 number:10]];
}

- (void)insertDataSourceWithObject:(id)item
{
    [self.dataSource insertObject:item atIndex:0];
}

- (NSUInteger)insertDataSourceWithNumber:(NSUInteger)number
{
    // first get message from database
    NSUInteger count = [self.dataSource count];
    NSArray *array = [self getMessagesFromDBFrom:count number:number];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, number)];
    if ([array count]) {
        [self.dataSource insertObjects:array atIndexes:indexes];
    }
    return [array count];
}

- (void)insertDataSource:(NSArray *)array
{
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array count])];
    [self insertDataSource:array atIndexes:indexes];
}

- (void)insertDataSource:(NSArray *)array atIndexes:(NSIndexSet *)indexes
{
    [self.dataSource insertObjects:array atIndexes:indexes];
}

- (void)removeDataSource
{
    [self.dataSource removeAllObjects];
}

static NSString *previousTime = nil;
- (void)addMessageItem:(NSDictionary *)dictionary
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    [dataDict setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDict setObject:[[NSDate date] stringYearMonthDayHourMinuteSecond] forKey:@"strTime"];
    
    [message setWithDict:dataDict];
    [message minuteOffSetStart:previousTime end:dataDict[@"strTime"]];
    
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDict[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
    [XHMessageTools saveMessages:dataDict];
}

- (NSArray *)getMessagesFromDBFrom:(NSUInteger)from number:(NSUInteger)number
{
    NSMutableArray *messages = [NSMutableArray array];
    NSArray *arrays = [XHMessageTools latestMessagesFrom:from number:number];
    for (NSMutableDictionary *dict in arrays) {
        [dict setObject:@(UUMessageFromOther) forKey:@"from"];
        
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dict];
        [message minuteOffSetStart:previousTime end:dict[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        if (message.showDateLabel) {
            previousTime = dict[@"strTime"];
        }
        previousTime = dict[@"strTime"];
        
        [messages addObject:messageFrame];
    }
    return messages;
}

- (void)dealloc
{
    [self.dataSource removeAllObjects];
}

@end
