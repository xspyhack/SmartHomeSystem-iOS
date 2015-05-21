//
//  XHValueViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/5/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHValueViewController.h"
#import "XHInputView.h"

@interface XHValueViewController ()
@property (nonatomic, strong) XHInputView *maxView;
@property (nonatomic, strong) XHInputView *minView;
@end

#pragma mark - life cycle

@implementation XHValueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_master) {
        _master = [NSString stringWithFormat:@"XH%@" ,self.title];
    }
    
    [self setupSubView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    [defaults setFloat:[self.maxView.value.text floatValue]
                  forKey:[NSString stringWithFormat:@"%@MaxValue", _master]];
    [defaults setFloat:[self.minView.value.text floatValue]
                  forKey:[NSString stringWithFormat:@"%@MinValue", _master]];
}

#pragma mark - setup view

- (void)setupSubView
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    CGFloat maxValue = [defaultes floatForKey:[NSString stringWithFormat:@"%@MaxValue", _master]];
    CGFloat minValue = [defaultes floatForKey:[NSString stringWithFormat:@"%@MinValue", _master]];
    
    CGRect minRect = CGRectMake(0, 100, self.view.frame.size.width, 44);
    self.minView = [[XHInputView alloc] initWithFrame:minRect];
    self.minView.label.text = @"Min";
    self.minView.value.text = [NSString stringWithFormat:@"%.1f", minValue];
    
    CGRect maxRect = CGRectMake(0, CGRectGetMaxY(minRect), self.view.frame.size.width, 44);
    self.maxView = [[XHInputView alloc] initWithFrame:maxRect];
    self.maxView.label.text = @"Max";
    self.maxView.value.text = [NSString stringWithFormat:@"%.1f", maxValue];
    
    [self.view addSubview:self.minView];
    [self.view addSubview:self.maxView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.maxView.value resignFirstResponder];
    [self.minView.value resignFirstResponder];
}

@end
