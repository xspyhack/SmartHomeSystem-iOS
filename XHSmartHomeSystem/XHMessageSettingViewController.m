//
//  XHMessageSettingViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessageSettingViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHColorTools.h"

@implementation XHMessageSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do any additional setup here.
    [self setupGroup];
    [self setupClearGroup];
}

- (void)setupGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *bgItem = [XHTableViewCellArrowItem itemWithTitle:@"Background"];
    XHTableViewCellArrowItem *searchItem = [XHTableViewCellArrowItem itemWithTitle:@"Search Histroy"];

    group.items = @[bgItem, searchItem];
}

- (void)setupClearGroup
{
    CGRect rect = CGRectMake(0, 45, self.view.frame.size.width, 40);
    UIButton *clear = [[UIButton alloc] initWithFrame:rect];
    clear.backgroundColor = [XHColorTools themeColor];
    [clear setTitle:@"Clear Message History" forState:UIControlStateNormal];
    [clear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = clear;
}

- (void)clear
{
    XHLog(@"Clear");
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.groups count] - 1) {
        return 30;
    }
    return 15;
}

@end
