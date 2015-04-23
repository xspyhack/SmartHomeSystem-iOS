//
//  XHAboutViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHAboutViewController.h"
#import "XHGaugeView.h"

@interface XHAboutViewController ()

@property (nonatomic, strong) XHGaugeView *speedometerView;
@property (nonatomic, strong) XHGaugeView *voltmeterView;

@end

@implementation XHAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat widht = self.view.frame.size.width;
    CGRect speedRect = CGRectMake((widht - 250)/2, 100, 250, 250);
    
    self.speedometerView = [[XHGaugeView alloc] initWithFrame:speedRect];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.speedometerView.textLabel.text = @"km/h";
    self.speedometerView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:18.0];
    self.speedometerView.lineWidth = 1.5;
    self.speedometerView.minorTickLength = 15.0;
    self.speedometerView.needle.width = 2.0;
    self.speedometerView.textLabel.textColor = [UIColor colorWithRed:0.7 green:1.0 blue:1.0 alpha:1.0];
    
    self.speedometerView.value = 0.0;
    [self.view addSubview:self.speedometerView];
    
    CGRect voltRect = CGRectMake((widht - 200)/2, 400, 200, 200);
    self.voltmeterView = [[XHGaugeView alloc] initWithFrame:voltRect];
    
    self.voltmeterView.startAngle = -3.0 * M_PI / 4.0;
    self.voltmeterView.arcLength = M_PI / 2.0;
    self.voltmeterView.textLabel.text = @"Volts";
    self.voltmeterView.minNumber = 5.0;
    self.voltmeterView.maxNumber = 20.0;
    self.voltmeterView.textLabel.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:15.0];
    self.voltmeterView.textLabel.textColor = [UIColor whiteColor];
    self.voltmeterView.needle.tintColor = [UIColor redColor];
    self.voltmeterView.needle.width = 1.0;
    
    self.voltmeterView.value = 14.4;
    [self.view addSubview:self.voltmeterView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(135, 600, 100, 30)];
    [btn setTitle:@"change" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)change
{
    self.speedometerView.value += 12;
}

@end
