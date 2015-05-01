//
//  XHSecurityViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSecurityViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellArrowItem.h"

@implementation XHSecurityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do any setup
    
    [self setupEncryptGroup];
    
}

- (void)setupEncryptGroup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults stringForKey:@"XHEncryptType"];
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellSwitchItem *encryptItem = [XHTableViewCellSwitchItem itemWithTitle:@"Encrypt"];
    XHTableViewCellArrowItem *encryptTypeItem = [XHTableViewCellArrowItem itemWithTitle:@"Encrypt Type"];
    encryptTypeItem.detail = type;
    encryptTypeItem.operation = ^ {
        
    };
    
    group.groupFooter = @"Enabling encrypt can improve security.";
    group.items = @[encryptItem, encryptItem];
}


@end
