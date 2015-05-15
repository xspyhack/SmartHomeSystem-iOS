//
//  XHFeaturesViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHFeaturesViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHCmdLineViewController.h"

@interface  XHFeaturesViewController ()

@property (nonatomic, getter=isCmdLineMode) BOOL cmdLineMode;

@end

@implementation XHFeaturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCommandLineGroup];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[self isCmdLineMode] forKey:@"XHCmdLineMode"];
}

- (void)setupCommandLineGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.cmdLineMode = [defaults boolForKey:@"XHCmdLineMode"];
    
    XHTableViewCellSwitchItem *clmItem = [XHTableViewCellSwitchItem itemWithTitle:@"Command Line Mode"];\
    clmItem.on = [self isCmdLineMode];
    clmItem.tapSwitch = ^{ self.cmdLineMode = !self.cmdLineMode; };
    
    group.groupFooter = @"Command line interface in a secret place. If you want to use it find it out first.";
    group.items = @[ clmItem ];
}

@end
