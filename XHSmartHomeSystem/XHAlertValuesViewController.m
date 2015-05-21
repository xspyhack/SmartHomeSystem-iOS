//
//  XHAlertValuesViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/18/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHAlertValuesViewController.h"
#import "XHInputView.h"

#define INPUTVIEW_HEIGHT 44

@interface  XHAlertValuesViewController ()

@property (nonatomic, strong) XHInputView *temperatureView;
@property (nonatomic, strong) XHInputView *humidityView;
@property (nonatomic, strong) XHInputView *smokeView;

@end

@implementation XHAlertValuesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:[self.temperatureView.value.text floatValue] forKey:@"XHTemperatureAlertValue"];
    [defaults setFloat:[self.humidityView.value.text floatValue] forKey:@"XHHumidityAlertValue"];
    [defaults setFloat:[self.smokeView.value.text floatValue] forKey:@"XHSmokeAlertValue"];
}

#pragma mark - setup view

- (void)setupSubView
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    CGFloat temperatureValue = [defaultes floatForKey:@"XHTemperatureAlertValue"];
    CGFloat humidityValue = [defaultes floatForKey:@"XHHumidityAlertValue"];
    CGFloat smokeValue = [defaultes floatForKey:@"XHSmokeAlertValue"];
    
    CGFloat width = self.view.frame.size.width;
    
    CGRect temperatureRect = CGRectMake(0, 100, width, INPUTVIEW_HEIGHT);
    self.temperatureView = [[XHInputView alloc] initWithFrame:temperatureRect];
    self.temperatureView.label.text = @"Temperature";
    self.temperatureView.value.text = [NSString stringWithFormat:@"%.1f", temperatureValue];
    
    CGRect humidityRect = CGRectMake(0, CGRectGetMaxY(temperatureRect), width, INPUTVIEW_HEIGHT);
    self.humidityView = [[XHInputView alloc] initWithFrame:humidityRect];
    self.humidityView.label.text = @"Humidity";
    self.humidityView.value.text = [NSString stringWithFormat:@"%.1f", humidityValue];
    
    CGRect smokeRect = CGRectMake(0, CGRectGetMaxY(humidityRect), width, INPUTVIEW_HEIGHT);
    self.smokeView = [[XHInputView alloc] initWithFrame:smokeRect];
    self.smokeView.label.text = @"Smoke";
    self.smokeView.value.text = [NSString stringWithFormat:@"%.1f", smokeValue];
    
    [self.view addSubview:self.temperatureView];
    [self.view addSubview:self.humidityView];
    [self.view addSubview:self.smokeView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.temperatureView.value resignFirstResponder];
    [self.humidityView.value resignFirstResponder];
    [self.smokeView resignFirstResponder];
}

@end
