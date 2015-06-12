//
//  XHMessageModel.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/14/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHMessageModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)populateDataSource;

- (NSUInteger)insertDataSourceWithNumber:(NSUInteger)number;
- (void)insertDataSourceWithObject:(id)item;
- (void)insertDataSource:(NSArray *)array;
- (void)insertDataSource:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeDataSource;

- (void)addMessageItem:(NSDictionary *)dictionary;

@end
