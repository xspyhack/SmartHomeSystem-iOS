//
//  XHNotificationsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNotificationsViewController.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellLabelItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellArrowItem.h"

typedef enum {
    EMShowSwitch = 0,
    EMSmokeAlertSwitch = 1,
    EMHumiAlertSwitch = 2,
    EMTempAlertSwitch = 3
}EMSwitch;

@interface XHNotificationsViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, assign) BOOL smokeSwitch;
@property (nonatomic, assign) BOOL humiditySwitch;
@property (nonatomic, assign) BOOL temperatureSwitch;

@end

@implementation XHNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    [self setupStatusGroup];
    [self setupShowGroup];
    [self setupTypeGroup];
}

- (void)setupStatusGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = @"Enable or disable XHSmartSystem Notifications via \"Settings\"->\"Notifications\" on your iPhone.";
    
    NSString *notification = [self.defaults objectForKey:@"NotificationEnabled"];
    
    XHTableViewCellLabelItem *notificationItem = [XHTableViewCellLabelItem itemWithTitle:@"Notifications"];
    notificationItem.text = notification;
    
    group.items = @[notificationItem];
}

- (void)setupShowGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupFooter = @"Message notifications will contain sender and summary when enabled.";
    
    self.showSwitch = [self.defaults boolForKey:@"showSwitch"];
    
    XHTableViewCellSwitchItem *showItem = [XHTableViewCellSwitchItem itemWithTitle:@"Show Preview Text"];
    showItem.on = self.showSwitch;
    showItem.tapSwitch = ^ {
        // click
        [self setSwitch:EMShowSwitch];
    };

    XHTableViewCellArrowItem *typeItem = [XHTableViewCellArrowItem itemWithTitle:@"Notification Type"];
    group.items = @[showItem, typeItem];
}

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    group.groupHeader = [@"Notifications of alerter" lowercaseString];
    
    // read defaults settings
    
    self.smokeSwitch = [self.defaults boolForKey:@"smokeAlertSwitch"];
    self.humiditySwitch = [self.defaults boolForKey:@"humidityAlertSwitch"];
    self.temperatureSwitch = [self.defaults boolForKey:@"temperatureAlertSwitch"];
    
    XHTableViewCellSwitchItem *smokeAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Smoke"];
    smokeAlertItem.on = self.smokeSwitch;
    smokeAlertItem.tapSwitch = ^ {
        [self setSwitch:EMSmokeAlertSwitch];
    };
    
    XHTableViewCellSwitchItem *humidityAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Humidity"];
    humidityAlertItem.on = self.humiditySwitch;
    humidityAlertItem.tapSwitch = ^ {
        [self setSwitch:EMHumiAlertSwitch];
    };
    
    XHTableViewCellSwitchItem *temperatureAlertItem = [XHTableViewCellSwitchItem itemWithTitle:@"Temperature"];
    temperatureAlertItem.on = self.temperatureSwitch;
    temperatureAlertItem.tapSwitch = ^ {
        [self setSwitch:EMTempAlertSwitch];
    };
    
    group.items = @[smokeAlertItem, humidityAlertItem, temperatureAlertItem];
}

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

- (void)viewDidDisappear:(BOOL)animated
{
    [self.defaults setBool:self.showSwitch forKey:@"showSwitch"];
    [self.defaults setBool:self.smokeSwitch forKey:@"smokeAlertSwitch"];
    [self.defaults setBool:self.humiditySwitch forKey:@"humidityAlertSwitch"];
    [self.defaults setBool:self.temperatureSwitch forKey:@"temperatureAlertSwitch"];
}

@end
