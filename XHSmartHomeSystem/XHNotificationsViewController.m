//
//  XHNotificationsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNotificationsViewController.h"
#import "XHDisturbViewController.h"
#import "XHAlertValuesViewController.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellLabelItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHColorTools.h"

typedef enum _EMSwitch {
    EMShowSwitch = 0,
    EMSmokeAlertSwitch = 1,
    EMHumiAlertSwitch = 2,
    EMTempAlertSwitch = 3
} EMSwitch;

@interface XHNotificationsViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, assign) BOOL smokeSwitch;
@property (nonatomic, assign) BOOL humiditySwitch;
@property (nonatomic, assign) BOOL temperatureSwitch;
@property (nonatomic, strong) UILabel *notificatonLabel;

@end

@implementation XHNotificationsViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    [self setupStatusGroup];
    [self setupShowGroup];
    [self setupTypeGroup];
    [self setupDisturbGroup];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.defaults setBool:self.showSwitch forKey:@"XHShowPreviewText"];
    [self.defaults setBool:self.smokeSwitch forKey:@"XHSmokeAlertor"];
    [self.defaults setBool:self.humiditySwitch forKey:@"XHHumidityAlertor"];
    [self.defaults setBool:self.temperatureSwitch forKey:@"XHTemperatureAlertor"];
}

#pragma mark - setup View

- (void)setupStatusGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = NSLocalizedString(@"Enable or disable XHSmartSystem Notifications via \"Settings\"->\"Notifications\" on your iPhone.", nil);
    
    XHTableViewCellLabelItem *notificationItem = [XHTableViewCellLabelItem itemWithTitle:NSLocalizedString(@"Notification", nil)];
    notificationItem.label = self.notificatonLabel;
    
    group.items = @[ notificationItem ];
}

- (void)setupShowGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = NSLocalizedString(@"Message notifications will contain sender and summary when enabled.", nil);
    
    self.showSwitch = [self.defaults boolForKey:@"XHShowPreviewText"];
    
    XHTableViewCellSwitchItem *showItem = [XHTableViewCellSwitchItem itemWithTitle:NSLocalizedString(@"Show Preview Text", nil)];
    showItem.on = self.showSwitch;
    showItem.tapSwitch = ^{ [self setSwitch:EMShowSwitch]; }; // tap
    
    group.items = @[ showItem ];
}

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupHeader = [NSLocalizedString(@"Notifications Alertor", nil) lowercaseString]; // it looks doesn't work well.
    
    // read defaults settings
    
    self.smokeSwitch = [self.defaults boolForKey:@"XHSmokeAlertor"];
    self.humiditySwitch = [self.defaults boolForKey:@"XHHumidityAlertor"];
    self.temperatureSwitch = [self.defaults boolForKey:@"XHTemperatureAlertor"];
    
    XHTableViewCellSwitchItem *smokeAlertItem = [XHTableViewCellSwitchItem itemWithTitle:NSLocalizedString(@"Smoke", nil)];
    smokeAlertItem.on = self.smokeSwitch;
    smokeAlertItem.tapSwitch = ^{ [self setSwitch:EMSmokeAlertSwitch]; };
    
    XHTableViewCellSwitchItem *humidityAlertItem = [XHTableViewCellSwitchItem itemWithTitle:NSLocalizedString(@"Humidity", nil)];
    humidityAlertItem.on = self.humiditySwitch;
    humidityAlertItem.tapSwitch = ^{ [self setSwitch:EMHumiAlertSwitch]; };
    
    XHTableViewCellSwitchItem *temperatureAlertItem = [XHTableViewCellSwitchItem itemWithTitle:NSLocalizedString(@"Temperature", nil)];
    temperatureAlertItem.on = self.temperatureSwitch;
    temperatureAlertItem.tapSwitch = ^{ [self setSwitch:EMTempAlertSwitch]; };
    
    XHTableViewCellArrowItem *alertValuesItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Alert Values", nil)];
    alertValuesItem.destinationContorller = [XHAlertValuesViewController class];
    
    group.groupFooter = NSLocalizedString(@"If turn off alertor, you can't get important system notification at first.", nil);
    group.items = @[ smokeAlertItem, humidityAlertItem, temperatureAlertItem, alertValuesItem ];
}

- (void)setupDisturbGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *disturbItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Don't Disturb", nil)];
    disturbItem.destinationContorller = [XHDisturbViewController class];
    
    group.items = @[ disturbItem ];
    
}

#pragma mark - event

- (void)setSwitch:(NSInteger)index
{
    switch (index) {
        case EMShowSwitch:
            self.showSwitch = !self.showSwitch;
            break;
        case EMSmokeAlertSwitch:
            self.smokeSwitch = !self.smokeSwitch;
            break;
        case EMHumiAlertSwitch:
            self.humiditySwitch = !self.humiditySwitch;
            break;
        case EMTempAlertSwitch:
            self.temperatureSwitch = !self.temperatureSwitch;
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (UILabel *)notificatonLabel
{
    if (!_notificatonLabel) {
        _notificatonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _notificatonLabel.textColor = [XHColorTools themeColor];
        NSString *notification = [self.defaults objectForKey:@"XHNotificationEnabled"];
        _notificatonLabel.text = NSLocalizedString(notification, nil);
        [_notificatonLabel sizeToFit];
    }
    return _notificatonLabel;
}

@end
