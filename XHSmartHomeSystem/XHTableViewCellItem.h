//
//  XHTableViewCellItem.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHTableViewCellItem : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) Class destinationContorller;

// method of click this cell
@property (nonatomic, copy) void (^clicked) (); // block must use copy property, tap cell
@property (nonatomic, copy) void (^tapSwitch) (); // block, tap UISwitch

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
