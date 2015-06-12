//
//  XHMessageTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHMessageTools : NSObject

+ (NSArray *)latestMessagesWithNumber:(NSUInteger)number;
+ (NSArray *)latestMessagesWithNumber:(NSUInteger)number userName:(NSString *)userName;
+ (NSArray *)latestMessagesFrom:(NSUInteger)from number:(NSUInteger)number;
+ (NSArray *)messagesAtIndexes:(NSIndexSet *)indexes;

+ (void)saveMessages:(NSDictionary *)dictionary;

// select
+ (NSArray *)messages;
+ (NSArray *)messagesWithSearchString:(NSString *)searchString;

// delete
+ (void)removeMessagesWithUserName:(NSString *)userName;
+ (void)removeMessages;

@end
