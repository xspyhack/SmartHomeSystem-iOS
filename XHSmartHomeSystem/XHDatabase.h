//
//  XHDatabase.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDatabase : NSObject

- (BOOL)open;
- (void)close;

- (void)createTable;

- (void)executeNonQuery:(NSString *)sql;
- (NSArray *)executeQuery:(NSString *)sql;

- (NSInteger)getCount:(NSString *)sql;

@end
