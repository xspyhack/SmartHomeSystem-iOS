//
//  XHMessageTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHMessageTools : NSObject

+ (NSArray *)latestMessageWithNumber:(NSUInteger)number;
+ (NSArray *)latestMessageWithNumber:(NSUInteger)number userName:(NSString *)userName;

+ (void)saveMessage:(NSDictionary *)dictionary;

@end
