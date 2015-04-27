//
//  XHLineView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/26/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLineView.h"
#import "XHColorTools.h"
#import "UICircularSlider.h"

#define XHLineViewHeight 309

@interface XHLineView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICircularSlider *circularSlider;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation XHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pull = NO; // can not pull down & pull up default.
        self.backgroundColor = [XHColorTools themeColor];
        [self setupView];
    }
    return self;
}

#pragma mark - interface

- (void)pullDown:(NSTimeInterval)animationDuration
{
    [UIView beginAnimations:@"PullDownLogoView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, 133.5, self.frame.size.width, XHLineViewHeight);
    
    [UIView commitAnimations];
}

- (void)pullUp
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.pull) {
        NSTimeInterval animationDuration = 0.5f;
        [UIView beginAnimations:@"PullUpLogoView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = CGRectMake(0, -XHLineViewHeight - 60, self.frame.size.width, XHLineViewHeight);
        //self.colorsView.center = self.view.center;
        
        [UIView commitAnimations];
    }
}

#pragma mark - setup

- (void)setupView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lineWidth = [defaults floatForKey:@"XHLineWidth"];
    
    CGRect rect = CGRectMake((self.frame.size.width - 200)/2, 30, 200, 200);
    self.circularSlider = [[UICircularSlider alloc] initWithFrame:rect];
    self.circularSlider.bgColor = self.backgroundColor;
    [self.circularSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
    self.circularSlider.minimumValue = 0;
    self.circularSlider.maximumValue = 3;
    self.circularSlider.value = lineWidth;
    self.circularSlider.continuous = NO;
    
    [self addSubview:self.circularSlider];
    
    CGRect btnRect = CGRectMake((self.frame.size.width - 50)/2, self.bounds.size.height - 130, 50, 50);
    self.saveBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self addSubview:self.saveBtn];
}

- (void)updateProgress:(UISlider *)sender {
    [self.circularSlider setValue:sender.value];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.circularSlider.value forKey:@"XHLineWidth"];
    [self pullUp];
}

@end
