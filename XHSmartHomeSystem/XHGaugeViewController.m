//
//  XHGaugeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/22/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGaugeViewController.h"
#import "XHGaugeView.h"
#import "XHColorTools.h"
#import "XHButton.h"
#import "XHRoomModel.h"
#import "XHRoomTools.h"
#import "XHSocketThread.h"

#define XHTempViewWidth (self.view.frame.size.width * 0.7)

@interface XHGaugeViewController ()<XHSocketThreadDelegate>

@property (nonatomic, strong) XHGaugeView *temperatureView;
@property (nonatomic, strong) XHGaugeView *humidityView;
@property (nonatomic, strong) XHGaugeView *smokeView;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) XHRoomTools *roomTools;

@end

@implementation XHGaugeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XHSocketThread shareInstance].delegate = self;
    //[[XHSocketThread shareInstance] connect];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.temperatureView.value = 30.f;
    self.humidityView.value = 55.f;
    self.smokeView.value = 9.f;

    //[super viewWillDisappear:animated];
    //[[XHSocketThread shareInstance] disconnect];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor = XHBlackColor;
    //self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = XHBlackColor;
    [self setup];
}

- (void)setup
{
    self.roomTools = [[XHRoomTools alloc] init];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.view addSubview:self.roomNameLabel];
    [self updateRoomNameLabel];
    
    CGRect tempRect = CGRectMake((width - XHTempViewWidth)/2, 100, XHTempViewWidth, XHTempViewWidth);
    
    self.temperatureView = [[XHGaugeView alloc] initWithFrame:tempRect];
    self.temperatureView.backgroundColor = self.view.backgroundColor;
    
    self.temperatureView.textLabel.text = NSLocalizedString(@"TEMP/°C", nil);
    self.temperatureView.minNumber = [defaults floatForKey:@"XHTemperatureMinValue"];
    self.temperatureView.maxNumber = [defaults floatForKey:@"XHTemperatureMaxValue"];
    self.temperatureView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:18.0];
    self.temperatureView.lineWidth = 1.5;
    self.temperatureView.minorTickLength = 15.0;
    self.temperatureView.needle.width = 2.0;
    self.temperatureView.needle.tintColor = [XHColorTools temperatureColor];
    self.temperatureView.textLabel.textColor = [XHColorTools temperatureColor];
    
    self.temperatureView.value = 0.f;
    [self.view addSubview:self.temperatureView];
    
    CGRect humiRect = CGRectMake(0, CGRectGetMaxY(tempRect)+50, width/2+10, width/2+10);
    self.humidityView = [[XHGaugeView alloc] initWithFrame:humiRect];
    self.humidityView.backgroundColor = self.view.backgroundColor;
    self.humidityView.startAngle = -3 * M_PI / 4.0;
    self.humidityView.arcLength = M_PI / 2.0;
    self.humidityView.textLabel.text = NSLocalizedString(@"HUMI/%RH", nil);
    self.humidityView.minNumber = [defaults floatForKey:@"XHHumidityMinValue"];
    self.humidityView.maxNumber = [defaults floatForKey:@"XHHumidityMaxValue"];
    self.humidityView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.humidityView.textLabel.textColor = [XHColorTools humidityColor];
    self.humidityView.tintColor = [UIColor colorWithRed:0.88 green:1 blue:1 alpha:1];
    self.humidityView.needle.tintColor = [XHColorTools humidityColor];
    self.humidityView.needle.width = 1.0;
    
    self.humidityView.value = 0.f;
    [self.view addSubview:self.humidityView];
    
    CGRect smokeRect = CGRectMake(width/2-10, CGRectGetMaxY(tempRect)+50, width/2+10, width/2+10);
    self.smokeView = [[XHGaugeView alloc] initWithFrame:smokeRect];
    self.smokeView.backgroundColor = self.view.backgroundColor;
    self.smokeView.startAngle = -3.0 * M_PI / 4.0;
    self.smokeView.arcLength = M_PI / 2.0;
    self.smokeView.textLabel.text = NSLocalizedString(@"SMOK/PPM", nil);
    self.smokeView.minNumber = [defaults floatForKey:@"XHSmokeMinValue"];
    self.smokeView.maxNumber = [defaults floatForKey:@"XHSmokeMaxValue"];
    self.smokeView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.smokeView.textLabel.textColor = [XHColorTools smokeColor];
    self.smokeView.tintColor = [UIColor colorWithRed:0.52 green:0.46 blue:0.98 alpha:1];
    self.smokeView.needle.tintColor = [XHColorTools smokeColor];
    self.smokeView.needle.width = 1.0;
    
    self.smokeView.value = 0.f;
    [self.view addSubview:self.smokeView];
    
    XHButton *button = [[XHButton alloc] initWithFrame:CGRectMake((width - width*0.2)/2, height - width*0.3, width*0.2, width*0.2)];
    
    [button setTitle:NSLocalizedString(@"dismiss", nil) forState:UIControlStateNormal];
    
    //[btn setTitleColor:[XHColorTools themeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReadBuffer:(NSString *)buffer
{
    for (XHRoomModel *model in [self.roomTools roomModelWithString:buffer]) {
        if (model && model.Id == self.roomId) {
            self.temperatureView.value = [model.temperature floatValue];
            self.humidityView.value = [model.humidity floatValue];
            self.smokeView.value = [model.smoke floatValue];
            self.roomId = model.Id;
            [self updateRoomNameLabel];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (void)updateRoomModel:(NSNotification *)notification
//{
//    if ([notification.name isEqualToString:XHUpdateRoomModelNotification]) {
//        NSString *buffer = [notification.userInfo objectForKey:@"BUFFER"];
//        XHRoomModel *model = [self.roomTools roomModelWithString:buffer];
//        
//        // update
//        self.smokeView.value = [model.temperature floatValue];
//        self.humidityView.value = [model.humidity floatValue];
//        self.smokeView.value = [model.smoke floatValue];
//    }
//}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (XHRoomModel *)roomModel
//{
//    if (!_roomModel) {
//        _roomModel = [[XHRoomModel alloc] init];
//    }
//    return _roomModel;
//}

//- (void)setRoomModel:(XHRoomModel *)roomModel
//{
//    _roomModel = roomModel;
//    switch (roomModel.Id) {
//        case XHParlour:
//            self.roomNameLabel.text = @"Parlour";
//            break;
//        case XHBedroom:
//            self.roomNameLabel.text = @"Bedroom";
//            break;
//        case XHKitchen:
//            self.roomNameLabel.text = @"Kitchen";
//            break;
//        case XHBathroom:
//            self.roomNameLabel.text = @"Bathroom";
//            break;
//        default:
//            break;
//    }
//}

- (void)updateRoomNameLabel
{
    switch (self.roomId) {
        case XHParlour:
            self.roomNameLabel.text = NSLocalizedString(@"Parlour", nil);
            break;
        case XHBedroom:
            self.roomNameLabel.text = NSLocalizedString(@"Bedroom", nil);
            break;
        case XHKitchen:
            self.roomNameLabel.text = NSLocalizedString(@"Kitchen", nil);
            break;
        case XHBathroom:
            self.roomNameLabel.text = NSLocalizedString(@"Bathroom", nil);
            break;
        default:
            break;
    }
}

- (void)setRoomId:(NSUInteger)roomId
{
    _roomId = roomId;
}

- (UILabel *)roomNameLabel
{
    if (!_roomNameLabel) {
        CGRect roomRect = CGRectMake(10, 40, self.view.frame.size.width - 20, 20);
        _roomNameLabel = [[UILabel alloc] initWithFrame:roomRect];
        _roomNameLabel.textAlignment = NSTextAlignmentCenter;
        _roomNameLabel.font = [UIFont boldSystemFontOfSize:19];
        _roomNameLabel.textColor = [XHColorTools themeColor];
    }
    return _roomNameLabel;
}

@end
