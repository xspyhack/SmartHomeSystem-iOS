//
//  XHStatusViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHStatusViewController.h"
#import "XHCoordinateView.h"
#import "XHColorTools.h"
#import "XHSocketThread.h"
#import "XHRoomModel.h"
#import "XHRoomTools.h"

#define BUTTON_WIDTH (self.view.frame.size.width*50/375.0f)
#define COORDINATE_WIDTH (self.view.frame.size.width*200/375.0f)
#define ALL_BUTTON_WIDTH (self.view.frame.size.width*80/375.0f)

@interface XHStatusViewController ()<XHSocketThreadDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, getter=isAllButtonSelected) BOOL allButtonSelected;
@property (nonatomic, strong) XHRoomTools *roomTools;

@end;

@implementation XHStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Control Center", nil);
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CGPoint center = self.view.center;
    float radius = self.view.frame.size.width*150/375.0f;
    
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
    self.allButtonSelected = NO;
    self.roomTools = [[XHRoomTools alloc] init];
    
    self.buttons = [NSMutableArray array];
    CGPoint center = self.view.center;
    
    CGRect coordinateRect = CGRectMake(0, 0, COORDINATE_WIDTH, COORDINATE_WIDTH);
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
    
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonCenter.x-ALL_BUTTON_WIDTH/2, buttonCenter.y-ALL_BUTTON_WIDTH/2, ALL_BUTTON_WIDTH, ALL_BUTTON_WIDTH)];
    allButton.layer.cornerRadius = ALL_BUTTON_WIDTH/2;
    allButton.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:.3f];
    [allButton setTitle:@"All" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.allButton = allButton;
    
    [self.view addSubview:allButton];
}

#pragma mark - delegate

- (void)writeWithRoom:(NSString *)room sensor:(NSString *)sensor status:(NSString *)status
{
    NSString *buffer = [NSString stringWithFormat:@"%@:LED_%@:%@;\n", room, sensor, status];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[XHSocketThread shareInstance] write:buffer];
    });
}

- (void)didReadBuffer:(NSString *)buffer
{
//    XHRoomModel *roomModel = [self.roomTools roomModelWithString:buffer];
//    
//    if (roomModel.temperatureStatus) {
//        [self setButtonSelected:YES index:(roomModel.Id * 3)];
//    } else {
//        [self setButtonSelected:NO index:(roomModel.Id * 3)];
//    }
//    if (roomModel.humidityStatus) {
//        [self setButtonSelected:YES index:(roomModel.Id * 3 + 1)];
//    } else {
//        [self setButtonSelected:NO index:(roomModel.Id * 3 + 1)];
//    }
//    if (roomModel.smokeStatus) {
//        [self setButtonSelected:YES index:(roomModel.Id * 3 + 2)];
//    } else {
//        [self setButtonSelected:NO index:(roomModel.Id * 3 + 2)];
//    }
    for (XHRoomModel *roomModel in [self.roomTools roomModelWithString:buffer]) {
        if (roomModel) {
            if (roomModel.temperatureStatus) {
                [self setButtonSelected:YES index:(roomModel.Id * 3)];
            } else {
                [self setButtonSelected:NO index:(roomModel.Id * 3)];
            }
            if (roomModel.humidityStatus) {
                [self setButtonSelected:YES index:(roomModel.Id * 3 + 1)];
            } else {
                [self setButtonSelected:NO index:(roomModel.Id * 3 + 1)];
            }
            if (roomModel.smokeStatus) {
                [self setButtonSelected:YES index:(roomModel.Id * 3 + 2)];
            } else {
                [self setButtonSelected:NO index:(roomModel.Id * 3 + 2)];
            }
        }
    }
}

#pragma mark - response event

- (void)buttonClicked:(UIButton *)button
{
    button.selected = !button.selected;
    // selected: on, unselected: off
    NSString *status = button.selected ? @"11111111" : @"00000000";
    
    NSString *room = [NSString string];
    NSString *sensor = [NSString string];
    
    switch (button.tag%3) {
        case 0:
            sensor = @"TEMP";
            break;
        case 1:
            sensor = @"HUMI";
            break;
        case 2:
            sensor = @"SMOK";
            break;
        default:
            break;
    }
    
    switch (button.tag/3) {
        case 0:
            room = @"00000001";
            break;
        case 1:
            room = @"00000002";
            break;
        case 2:
            room = @"00000003";
            break;
        case 3:
            room = @"00000004";
            break;
        default:
            break;
    }
    
    XHLog(@"status: %@", status);
    [self writeWithRoom:room sensor:sensor status:status];
    
    [self setButtonBackgroundColor:button];
}

#pragma mark - private methods

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

- (float)angle2Radians:(float)angle
{
    return (angle) /180.0 * M_PI;
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

- (void)setButtonSelected:(BOOL)selected index:(NSUInteger)index
{
    UIButton *button = self.buttons[index];
    button.selected = selected;
    [self setButtonBackgroundColor:button];
}

- (void)allButtonClicked
{
    
    for (UIButton *button in self.buttons) {
        [UIView animateWithDuration:.7f
                              delay:.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.selected = self.isAllButtonSelected ? YES : NO;
                             [self buttonClicked:button];
                         } completion:nil];
    }
    self.allButtonSelected = !self.allButtonSelected;
    self.allButton.backgroundColor = self.allButtonSelected ? ([[XHColorTools themeColor] colorWithAlphaComponent:0.98f]) : ([[XHColorTools themeColor] colorWithAlphaComponent:0.3f]);
}

@end
