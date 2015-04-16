//
//  XHTableViewCellGroup.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHTableViewCellGroup : NSObject

@property (nonatomic, copy) NSString *groupHeader;
@property (nonatomic, copy) NSString *groupFooter;

@property (nonatomic, strong) NSArray *items; // all group item

+ (instancetype)group;

@end
