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

- (void)populateRandomDataSource {
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:[self getMessagesFromDB]];
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
    [XHMessageTools saveMessage:dataDict];
}

- (NSArray *)getMessagesFromDB
{
    NSMutableArray *messages = [NSMutableArray array];
    NSArray *arrays = [XHMessageTools latestMessageWithNumber:10]; // get the last 10 item
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

@end
