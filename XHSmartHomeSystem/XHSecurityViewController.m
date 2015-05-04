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
#import "XHEncryptTypeViewController.h"

@interface XHSecurityViewController ()

@property (nonatomic, assign) BOOL checkin;

@end

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
    BOOL checkin = [defaults boolForKey:@"XHCheckIn"];
    
    NSInteger index = [defaults integerForKey:@"XHEncryptType"];
    NSString *type;
    if (index == 0) {
        type = @"None";
    } else if (index == 1) {
        type = @"MD5";
    } else {
        type = @"AES";
    }
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellSwitchItem *checkItem = [XHTableViewCellSwitchItem itemWithTitle:@"Check in"];
    checkItem.on = checkin;
    checkItem.tapSwitch = ^{
        self.checkin = !self.checkin;
    };
    
    XHTableViewCellArrowItem *encryptTypeItem = [XHTableViewCellArrowItem itemWithTitle:@"Encrypt Type"];
    encryptTypeItem.detail = type;
    encryptTypeItem.destViewContorller = [XHEncryptTypeViewController class];
    
    group.groupFooter = @"Enabling encrypt can improve security.";
    group.items = @[checkItem, encryptTypeItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.checkin forKey:@"XHCheckIn"];
}

@end
