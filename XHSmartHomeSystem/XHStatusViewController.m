//
//  XHStatusViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHStatusViewController.h"
#import "XHCoordinateView.h"
#import "XHButton.h"
#import "XHColorTools.h"
#import "XHSocketThread.h"

#define BUTTON_WIDTH 50

@interface XHStatusViewController ()<XHSocketThreadDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;

@end;

@implementation XHStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CGPoint center = self.view.center;
    float radius = 150.0f;
    
    CGPoint buttonCenter = CGPointMake(center.x, center.y);
    for (int i = 0; i < 12; i++) {
        float radians = [self angle2Radians:(30*i+15)];
        CGFloat x = buttonCenter.x + radius * cos(radians) - BUTTON_WIDTH/2;
        CGFloat y = buttonCenter.y - radius * sin(radians) - BUTTON_WIDTH/2;
        CGRect rect = CGRectMake(x, y, BUTTON_WIDTH, BUTTON_WIDTH);
        UIButton *button = self.buttons[i];
        [UIView animateWithDuration:0.5f animations:^{
            button.frame = rect;
        }];
    }
}

- (void)setup
{
    self.buttons = [NSMutableArray array];
    CGPoint center = self.view.center;
    
    CGRect coordinateRect = CGRectMake(0, 0, 200, 200);
    XHCoordinateView *coordinateView = [[XHCoordinateView alloc] initWithFrame:coordinateRect];
    coordinateView.center = center;
    [self.view addSubview:coordinateView];
    
    CGPoint buttonCenter = CGPointMake(center.x, center.y);
    for (int i = 0; i < 12; i++) {
        CGFloat x = buttonCenter.x - BUTTON_WIDTH/2;
        CGFloat y = buttonCenter.y - BUTTON_WIDTH/2;
        CGRect rect = CGRectMake(x, y, BUTTON_WIDTH, BUTTON_WIDTH);
        UIButton *button = [self buttonWithFrame:rect tag:i];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        [self setButtonBackgroundColor:button];
        [self.buttons addObject:button];
    }
    
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonCenter.x-40, buttonCenter.y-40, 80, 80)];
    allButton.layer.cornerRadius = 40;
    allButton.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:.98f];
    [allButton setTitle:@"All" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:allButton];
}

- (float)angle2Radians:(float)angle
{
    return (angle) /180.0 * M_PI;
}

- (UIButton *)buttonWithFrame:(CGRect)frame tag:(NSUInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    NSString *title;
    switch (tag%3) {
        case 0:
            title = @"T";
            break;
        case 1:
            title = @"H";
            break;
        case 2:
            title = @"S";
            break;
        default:
            title = @"X";
            break;
    }
    button.layer.cornerRadius = BUTTON_WIDTH / 2;

    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

- (void)buttonClicked:(UIButton *)button
{
    // selected: off, unselected: on
    [button setSelected:!button.selected];
    NSString *status = button.state ? @"11111111" : @"00000000";
    
    NSString *room = [NSString string];
    NSString *sensor = [NSString string];
    
    switch (button.tag) {
        case 0:
            room = @"00000001";
            sensor = @"TEMP";
            break;
        case 1:
            room = @"00000001";
            sensor = @"HUMI";
            break;
        case 2:
            room = @"00000001";
            sensor = @"SMOK";
            break;
        case 3:
            room = @"00000002";
            sensor = @"TEMP";
            break;
        case 4:
            room = @"00000002";
            sensor = @"HUMI";
            break;
        case 5:
            room = @"00000002";
            sensor = @"SMOK";
            break;
        case 6:
            room = @"00000003";
            sensor = @"TEMP";
            break;
        case 7:
            room = @"00000003";
            sensor = @"HUMI";
            break;
        case 8:
            room = @"00000003";
            sensor = @"SMOK";
            break;
        case 9:
            room = @"00000004";
            sensor = @"TEMP";
            break;
        case 10:
            room = @"00000004";
            sensor = @"HUMI";
            break;
        case 11:
            room = @"00000004";
            sensor = @"SMOK";
            break;
        default:
            break;
    }
    [self writeWithRoom:room sensor:sensor status:status];
    
    [self setButtonBackgroundColor:button];
}

- (void)setButtonBackgroundColor:(UIButton *)button
{
    UIColor *color;
    switch (button.tag%3) {
        case 0:
            color = [XHColorTools temperatureColor];
            break;
        case 1:
            color = [XHColorTools humidityColor];
            break;
        case 2:
            color = [XHColorTools smokeColor];
            break;
        default:
            color = XHColor;
            break;
    }
    
    if (button.selected) {
        button.backgroundColor = [color colorWithAlphaComponent:.9f];
    } else {
        button.backgroundColor = [color colorWithAlphaComponent:.1f];
    }
}

- (void)allButtonClicked
{
    
}

- (void)writeWithRoom:(NSString *)room sensor:(NSString *)sensor status:(NSString *)status
{
    NSString *buffer = [NSString stringWithFormat:@"%@:LED_%@:%@;\n", room, sensor, status];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[XHSocketThread shareInstance] write:buffer];
    });
}

@end
