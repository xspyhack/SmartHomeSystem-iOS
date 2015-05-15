//
//  XHNotificationsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNotificationsViewController.h"
#import "XHNotificationTypeViewController.h"
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.defaults setBool:self.showSwitch forKey:@"XHShowSwitch"];
    [self.defaults setBool:self.smokeSwitch forKey:@"XHSmokeAlertSwitch"];
    [self.defaults setBool:self.humiditySwitch forKey:@"XHHumidityAlertSwitch"];
    [self.defaults setBool:self.temperatureSwitch forKey:@"XHTemperatureAlertSwitch"];
}

#pragma mark - setup View

- (void)setupStatusGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = @"Enable or disable XHSmartSystem Notifications via \"Settings\"->\"Notifications\" on your iPhone.";
    
    XHTableViewCellLabelItem *notificationItem = [XHTableViewCellLabelItem itemWithTitle:@"Notifications"];
    notificationItem.label = self.notificatonLabel;
    
    group.items = @[ notificationItem ];
}

- (void)setupShowGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = @"Message notifications will contain sender and summary when enabled.";
    
    self.showSwitch = [self.defaults boolForKey:@"XHShowPreviewText"];
    
    XHTableViewCellSwitchItem *showItem = [XHTableViewCellSwitchItem itemWithTitle:@"Show Preview Text"];
    showItem.on = self.showSwitch;
    showItem.tapSwitch = ^{ [self setSwitch:EMShowSwitch]; }; // tap

    XHTableViewCellArrowItem *typeItem = [XHTableViewCellArrowItem itemWithTitle:@"Notification Type"];
    typeItem.destinationContorller = [XHNotificationTypeViewController class];
    
    group.items = @[ showItem, typeItem ];
}

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupHeader = [@"Notifications Alerter" lowercaseString]; // it looks doesn't work well.
    
    // read defaults settings
    
    self.smokeSwitch = [self.defaults boolForKey:@"XHSmokeAlertSwitch"];
    self.humiditySwitch = [self.defaults boolForKey:@"XHHumidityAlertSwitch"];
    self.temperatureSwitch = [self.defaults boolForKey:@"XHTemperatureAlertSwitch"];
    
    XHTableViewCellSwitchItem *smokeAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Smoke"];
    smokeAlertItem.on = self.smokeSwitch;
    smokeAlertItem.tapSwitch = ^{ [self setSwitch:EMSmokeAlertSwitch]; };
    
    XHTableViewCellSwitchItem *humidityAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Humidity"];
    humidityAlertItem.on = self.humiditySwitch;
    humidityAlertItem.tapSwitch = ^{ [self setSwitch:EMHumiAlertSwitch]; };
    
    XHTableViewCellSwitchItem *temperatureAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Temperature"];
    temperatureAlertItem.on = self.temperatureSwitch;
    temperatureAlertItem.tapSwitch = ^{ [self setSwitch:EMTempAlertSwitch]; };
    
    group.groupFooter = @"If turn off alert, you can't get important system notification at first.";
    group.items = @[ smokeAlertItem, humidityAlertItem, temperatureAlertItem ];
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
        NSString *notification = [self.defaults objectForKey:@"NotificationEnabled"];
        _notificatonLabel.text = notification;
        [_notificatonLabel sizeToFit];
    }
    return _notificatonLabel;
}


@end
