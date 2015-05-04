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

#define XHTempViewWidth (self.view.frame.size.width * 0.7)

typedef enum {
    XHParlour = 0,
    XHBedroom = 1,
    XHKitchen = 2,
    XHBathroom = 3
}XHRoomId;


@interface XHGaugeViewController ()

@property (nonatomic, strong) XHGaugeView *temperatureView;
@property (nonatomic, strong) XHGaugeView *humidityView;
@property (nonatomic, strong) XHGaugeView *smokeView;
@property (nonatomic, strong) UILabel *roomNameLabel;

@end

@implementation XHGaugeViewController

- (void)viewDidLoad
{
    //self.navigationController.navigationBar.barTintColor = XHBlackColor;
    //self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = XHBlackColor;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGRect roomRect = CGRectMake(10, 40, self.view.frame.size.width - 20, 20);
    _roomNameLabel = [[UILabel alloc] initWithFrame:roomRect];
    _roomNameLabel.textAlignment = NSTextAlignmentCenter;
    _roomNameLabel.font = [UIFont boldSystemFontOfSize:19];
    _roomNameLabel.textColor = [XHColorTools themeColor];
    [self setRoomName];
    [self.view addSubview:_roomNameLabel];
    
    CGRect tempRect = CGRectMake((width - XHTempViewWidth)/2, 100, XHTempViewWidth, XHTempViewWidth);
    
    self.temperatureView = [[XHGaugeView alloc] initWithFrame:tempRect];
    self.temperatureView.backgroundColor = self.view.backgroundColor;
    
    self.temperatureView.textLabel.text = @"°C";
    self.temperatureView.minNumber = -40;
    self.temperatureView.maxNumber = 60;
    self.temperatureView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:18.0];
    self.temperatureView.lineWidth = 1.5;
    self.temperatureView.minorTickLength = 15.0;
    self.temperatureView.needle.width = 2.0;
    self.temperatureView.needle.tintColor = [XHColorTools temperatureColor];
    self.temperatureView.textLabel.textColor = [XHColorTools temperatureColor];
    
    self.temperatureView.value = 0.0;
    [self.view addSubview:self.temperatureView];
    
    CGRect humiRect = CGRectMake(0, CGRectGetMaxY(tempRect)+50, width/2+10, width/2+10);
    self.humidityView = [[XHGaugeView alloc] initWithFrame:humiRect];
    self.humidityView.backgroundColor = self.view.backgroundColor;
    self.humidityView.startAngle = -3 * M_PI / 4.0;
    self.humidityView.arcLength = M_PI / 2.0;
    self.humidityView.textLabel.text = @"%RH";
    self.humidityView.minNumber = 20.0;
    self.humidityView.maxNumber = 80.0;
    self.humidityView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.humidityView.textLabel.textColor = [XHColorTools humidityColor];
    self.humidityView.tintColor = [UIColor colorWithRed:0.88 green:1 blue:1 alpha:1];
    self.humidityView.needle.tintColor = [XHColorTools humidityColor];
    self.humidityView.needle.width = 1.0;
    
    self.humidityView.value = 64.4;
    [self.view addSubview:self.humidityView];
    
    CGRect smokeRect = CGRectMake(width/2-10, CGRectGetMaxY(tempRect)+50, width/2+10, width/2+10);
    self.smokeView = [[XHGaugeView alloc] initWithFrame:smokeRect];
    self.smokeView.backgroundColor = self.view.backgroundColor;
    self.smokeView.startAngle = -3.0 * M_PI / 4.0;
    self.smokeView.arcLength = M_PI / 2.0;
    self.smokeView.textLabel.text = @"PPM";
    self.smokeView.minNumber = 5.0;
    self.smokeView.maxNumber = 20.0;
    self.smokeView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.smokeView.textLabel.textColor = [XHColorTools smokeColor];
    self.smokeView.tintColor = [UIColor colorWithRed:0.52 green:0.46 blue:0.98 alpha:1];
    self.smokeView.needle.tintColor = [XHColorTools smokeColor];
    self.smokeView.needle.width = 1.0;
    
    self.smokeView.value = 9.4;
    [self.view addSubview:self.smokeView];
    
    XHButton *btn = [[XHButton alloc] initWithFrame:CGRectMake((width - width*0.2)/2, height - width*0.3, width*0.2, width*0.2)];
    
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    
    //[btn setTitleColor:[XHColorTools themeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)setRoomId:(NSInteger)roomId
{
    _roomId = roomId;
}

- (void)setRoomName
{
    if (_roomId == XHParlour) {
        _roomNameLabel.text = @"parlour";
    } else if (_roomId == XHBedroom) {
        _roomNameLabel.text = @"bedroom";
    } else if (_roomId == XHKitchen) {
        _roomNameLabel.text = @"kitchen";
    } else if (_roomId == XHBathroom) {
        _roomNameLabel.text = @"bathroom";
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
