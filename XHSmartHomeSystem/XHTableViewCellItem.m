//
//  XHTableViewCellItem.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTableViewCellItem.h"

@implementation XHTableViewCellItem

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName
{
    XHTableViewCellItem *item = [[self alloc] init];
    item.title = title;
    item.iconName = iconName;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    //XHTableViewCellItem *item = [[XHTableViewCellItem alloc] init];
    //item.title = title;
    return [self itemWithTitle:title iconName:nil];
}

@end
