//
//  XHGaugeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/22/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGaugeViewController.h"
#import "XHGaugeView.h"

@interface XHGaugeViewController ()

@property (nonatomic, strong) XHGaugeView *temperatureView;
@property (nonatomic, strong) XHGaugeView *humidityView;
@property (nonatomic, strong) XHGaugeView *smokeView;

@end

@implementation XHGaugeViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = XHBlackColor;
    CGFloat width = self.view.frame.size.width;
    CGRect tempRect = CGRectMake((width - 250)/2, 100, 250, 250);
    
    self.temperatureView = [[XHGaugeView alloc] initWithFrame:tempRect];
    self.temperatureView.backgroundColor = self.view.backgroundColor;
    
    self.temperatureView.textLabel.text = @"°C";
    self.temperatureView.minNumber = -40;
    self.temperatureView.maxNumber = 60;
    self.temperatureView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:18.0];
    self.temperatureView.lineWidth = 1.5;
    self.temperatureView.minorTickLength = 15.0;
    self.temperatureView.needle.width = 2.0;
    self.temperatureView.textLabel.textColor = [UIColor colorWithRed:0.7 green:1.0 blue:1.0 alpha:1.0];
    
    self.temperatureView.value = 0.0;
    [self.view addSubview:self.temperatureView];
    
    CGRect humiRect = CGRectMake(0, 400, width/2+10, width/2+10);
    self.humidityView = [[XHGaugeView alloc] initWithFrame:humiRect];
    self.humidityView.backgroundColor = self.view.backgroundColor;
    self.humidityView.startAngle = -3 * M_PI / 4.0;
    self.humidityView.arcLength = M_PI / 2.0;
    self.humidityView.textLabel.text = @"%RH";
    self.humidityView.minNumber = 20.0;
    self.humidityView.maxNumber = 80.0;
    self.humidityView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.humidityView.textLabel.textColor = [UIColor whiteColor];
    self.humidityView.needle.tintColor = [UIColor greenColor];
    self.humidityView.needle.width = 1.0;
    
    self.humidityView.value = 64.4;
    [self.view addSubview:self.humidityView];
    
    CGRect smokeRect = CGRectMake(width/2-10, 400, width/2+10, width/2+10);
    self.smokeView = [[XHGaugeView alloc] initWithFrame:smokeRect];
    self.smokeView.backgroundColor = self.view.backgroundColor;
    self.smokeView.startAngle = -3.0 * M_PI / 4.0;
    self.smokeView.arcLength = M_PI / 2.0;
    self.smokeView.textLabel.text = @"PPM";
    self.smokeView.minNumber = 5.0;
    self.smokeView.maxNumber = 20.0;
    self.smokeView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.smokeView.textLabel.textColor = XHOrangeColor;
    self.smokeView.needle.tintColor = [UIColor redColor];
    self.smokeView.needle.width = 1.0;
    
    self.smokeView.value = 9.4;
    [self.view addSubview:self.smokeView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(135, 600, 100, 30)];
    [btn setTitle:@"change" forState:UIControlStateNormal];
    //btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:XHOrangeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)change
{
    self.temperatureView.value += 12;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
