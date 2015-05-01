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

@implementation XHFeaturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCommandLineGroup];
}

- (void)setupCommandLineGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellSwitchItem *clmItem = [XHTableViewCellSwitchItem itemWithTitle:@"Command Line Mode"];
    XHTableViewCellArrowItem *goItem = [XHTableViewCellArrowItem itemWithTitle:@"Go"];
    
    group.items = @[clmItem, goItem];
}

@end
