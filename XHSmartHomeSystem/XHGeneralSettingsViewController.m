//
//  XHGeneralSettingsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGeneralSettingsViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHAboutViewController.h"


@implementation XHGeneralSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGeneralGroup];
    [self setupLinkOutGroup];
}

- (void)setupGeneralGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *generalItem = [XHTableViewCellArrowItem itemWithTitle:@"General" iconName:@"general"];
    generalItem.destViewContorller = [XHAboutViewController class];
    XHTableViewCellArrowItem *displayItem = [XHTableViewCellArrowItem itemWithTitle:@"Display" iconName:@"display"];
    group.items = @[generalItem, displayItem];
}

- (void)setupLinkOutGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellItem *linkOutItem = [XHTableViewCellItem itemWithTitle:@"Link out"];
    
    group.items = @[linkOutItem];
}

@end
