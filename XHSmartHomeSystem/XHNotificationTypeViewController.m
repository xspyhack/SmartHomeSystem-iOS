//
//  XHNotificationTypeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/27/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNotificationTypeViewController.h"
#import "XHTimePickerView.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellCheckmarkItem.h"
#import "XHTableViewCellLabelItem.h"
#import "XHTableViewCellSwitchItem.h"

@interface XHNotificationTypeViewController ()
@property (nonatomic, strong) XHTimePickerView *timePicker;
@end

@implementation XHNotificationTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initailization code
    
    [self setupTypeGroup];
    [self setupTimeGroup];
    [self setupDatePicker];
}

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellCheckmarkItem *alertItem = [XHTableViewCellCheckmarkItem itemWithTitle:@"Alert"];
    alertItem.type = UITableViewCellAccessoryCheckmark;
    
    XHTableViewCellCheckmarkItem *msgItem = [XHTableViewCellCheckmarkItem itemWithTitle:@"Msg"];
    
    group.groupHeader = @"Notification Push Type";
    group.items = @[alertItem, msgItem];
}

- (void)setupTimeGroup
{
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];

    //group.items = @[self.timeItem];
    group.groupHeader = @"Push Time Setting";
}

- (void)setupDatePicker
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *startTime = [defaults objectForKey:@"XHNotificationStartTime"];
    NSString *endTime = [defaults objectForKey:@"XHNotificationEndTime"];
    
    CGRect rect = CGRectMake(0, 200, self.view.frame.size.width, 300);
    self.timePicker = [[XHTimePickerView alloc] initWithFrame:rect];
    self.timePicker.startTime = startTime;
    self.timePicker.endTime = endTime;
    
    [self.view addSubview:self.timePicker];
}

@end
