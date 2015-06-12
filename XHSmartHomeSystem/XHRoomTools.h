//
//  XHRoomTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class XHRoomModel;

@interface XHRoomTools : NSObject

- (NSArray *)roomModelWithString:(NSString *)aString;

/* 
 return recent week/month/year data
 */
+ (NSArray *)recentWeekWithRoomId:(NSUInteger)roomId;
+ (NSArray *)recentMonthWithRoomId:(NSUInteger)roomId;
+ (NSArray *)recentYearWithRoomId:(NSUInteger)roomId;

/*
 retuan average/max/min value
 */
+ (NSDictionary *)weekDataWithRoomId:(NSUInteger)roomId;
+ (NSDictionary *)monthDataWithRoomId:(NSUInteger)roomId;
+ (NSDictionary *)yearDataWithRoomId:(NSUInteger)roomId;

+ (NSArray *)limitsDataWithRoomId:(NSUInteger)roomId;

+ (BOOL)saveIfIsFirstDataOfToday:(XHRoomModel *)model;

@end
