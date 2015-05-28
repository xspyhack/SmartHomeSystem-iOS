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

- (void)populateRandomDataSource;

- (void)addMessageItem:(NSDictionary *)dictionary;

@end
