//
//  XHDisturbViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/18/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHDisturbViewController.h"
#import "XHTimePickerView.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellCheckmarkItem.h"
#import "XHTableViewCellLabelItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHColorTools.h"
#import "XHInputView.h"

#define XHPickerViewHeight 252

typedef enum _EMMessageType {
    EMAlert = 0,
    EMText = 1
} EMMessageType;

@interface XHDisturbViewController ()
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation XHDisturbViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initailization code
    
    [self setupTypeGroup];
    [self setupTimeGroup];
}

#pragma mark - setup View

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [defaults integerForKey:@"XHMessageType"];
    
    XHTableViewCellCheckmarkItem *alertItem = [XHTableViewCellCheckmarkItem itemWithTitle:NSLocalizedString(@"Alertor", nil)];
    alertItem.clicked = ^{ [self setCheckmark:EMAlert]; };
    
    XHTableViewCellCheckmarkItem *textItem = [XHTableViewCellCheckmarkItem itemWithTitle:NSLocalizedString(@"Message Text", nil)];
    textItem.clicked = ^{ [self setCheckmark:EMText]; };
    
    if (index == 0) {
        alertItem.type = UITableViewCellAccessoryCheckmark;
    } else {
        textItem.type = UITableViewCellAccessoryCheckmark;
    }
    
    group.groupHeader = NSLocalizedString(@"Notification Push Type", nil);
    group.items = @[ alertItem, textItem ];
}

- (void)setupTimeGroup
{
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellLabelItem *timeItem = [XHTableViewCellLabelItem itemWithTitle:NSLocalizedString(@"Time", nil)];
    timeItem.label = self.timeLabel;
    timeItem.clicked = ^{ [self setupTimePicker]; };
    
    group.items = @[ timeItem ];
    group.groupHeader = NSLocalizedString(@"Push Time Setting", nil);
}

- (void)setupTimePicker
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *startTime = [defaults objectForKey:@"XHNotificationStartTime"];
    NSString *endTime = [defaults objectForKey:@"XHNotificationEndTime"];
    
    CGRect rect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, XHPickerViewHeight);
    XHTimePickerView *timePicker = [[XHTimePickerView alloc] initWithFrame:rect];
    timePicker.startTime = startTime;
    timePicker.endTime = endTime;
    timePicker.done = ^{ [self updateTimeLabel]; };
    [timePicker show];
    
    [self.view addSubview:timePicker];
}

#pragma mark - event

- (void)updateTimeLabel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *startTime = [defaults objectForKey:@"XHNotificationStartTime"];
    NSString *endTime = [defaults objectForKey:@"XHNotificationEndTime"];
    self.timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Every day %@ to %@", nil), startTime, endTime];
    [self.timeLabel sizeToFit];
}

- (void)setCheckmark:(NSInteger)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (index) {
        case EMAlert:
            [defaults setInteger:EMAlert forKey:@"XHMessageType"];
            break;
        case EMText:
            [defaults setInteger:EMText forKey:@"XHMessageType"];
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [XHColorTools themeColor];
        [self updateTimeLabel];
    }
    return _timeLabel;
}

@end
