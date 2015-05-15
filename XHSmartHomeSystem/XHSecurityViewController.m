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

@property (nonatomic, getter=isCheckin) BOOL checkin;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) XHTableViewCellArrowItem *encryptTypeItem;
@end

@implementation XHSecurityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do any setup
    
    [self setupEncryptGroup];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // update tableviewcell content
    [self getUserDefaults];
    
    self.encryptTypeItem.detail = self.type;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[self isCheckin] forKey:@"XHCheckIn"];
}

#pragma mark - setup

- (void)setupEncryptGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    [self getUserDefaults];
    
    XHTableViewCellSwitchItem *checkItem = [XHTableViewCellSwitchItem itemWithTitle:@"Check in"];
    checkItem.on = [self isCheckin];
    checkItem.tapSwitch = ^{
        self.checkin = !self.checkin;
    };
    
    self.encryptTypeItem = [XHTableViewCellArrowItem itemWithTitle:@"Encrypt Type"];
    self.encryptTypeItem.detail = self.type;
    self.encryptTypeItem.destinationContorller = [XHEncryptTypeViewController class];
    
    group.groupFooter = @"Enabling encrypt can improve security.";
    group.items = @[ checkItem, self.encryptTypeItem ];
}

#pragma mark - private methods

- (void)getUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.checkin = [defaults boolForKey:@"XHCheckIn"];
    
    NSInteger index = [defaults integerForKey:@"XHEncryptType"];

    if (index == 0) {
        self.type = @"None";
    } else if (index == 1) {
        self.type = @"MD5";
    } else {
        self.type = @"AES";
    }
}

@end
