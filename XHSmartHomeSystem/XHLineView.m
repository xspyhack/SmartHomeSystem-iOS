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
#import "XHButton.h"

#define XHLineViewHeight (self.frame.size.width + 10)
#define XHCircularSliderWidth (self.frame.size.width - 100)

@interface XHLineView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICircularSlider *circularSlider;
@property (nonatomic, strong) XHButton *saveBtn;
@end

@implementation XHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pull = NO; // can not pull down & pull up default.
        self.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:0.8];
        [self setupView];
    }
    return self;
}

#pragma mark - interface

- (void)pullDown:(NSTimeInterval)animationDuration
{
    // this method had be discouraged, but not be deprecated, it should use block to instead
    /*
     [UIView beginAnimations:@"PullDownLineView" context:nil];
     [UIView setAnimationDuration:animationDuration];
     self.frame = CGRectMake(0, 90, self.frame.size.width, XHLineViewHeight);
     //self.colorsView.center = self.view.center;
     
     [UIView commitAnimations];
     */
    
    // use block
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, 90, self.frame.size.width, XHLineViewHeight);
    }];
}

- (void)pullUp
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.pull) {
        // this method had be discouraged, but not be deprecated, it should use block to instead
        /*
         NSTimeInterval animationDuration = 0.5f;
         [UIView beginAnimations:@"PullUpLineView" context:nil];
         [UIView setAnimationDuration:animationDuration];
         self.frame = CGRectMake(0, -XHColorsViewHeight-66, self.frame.size.width, XHLineViewHeight);
         //self.colorsView.center = self.view.center;
         [UIView commitAnimations];
         */
        
        // use block
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(0, -XHLineViewHeight-66, self.frame.size.width, XHLineViewHeight);
        }];
    }
}

#pragma mark - setup

- (void)setupView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lineWidth = [defaults floatForKey:@"XHLineWidth"];
    
    CGRect rect = CGRectMake((self.frame.size.width - XHCircularSliderWidth)/2, 30, XHCircularSliderWidth, XHCircularSliderWidth);
    self.circularSlider = [[UICircularSlider alloc] initWithFrame:rect];
    self.circularSlider.bgColor = [UIColor clearColor];
    [self.circularSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
    self.circularSlider.minimumValue = 0;
    self.circularSlider.maximumValue = 3;
    self.circularSlider.value = lineWidth;
    self.circularSlider.continuous = NO;
    
    [self addSubview:self.circularSlider];
    
    CGFloat saveBtnWidth = self.frame.size.width / 6.4;
    CGFloat saveBtnX = (self.frame.size.width - saveBtnWidth)/2;
    CGFloat saveBtnY = self.frame.size.height - saveBtnWidth - 30;
    CGRect btnRect = CGRectMake(saveBtnX, saveBtnY, saveBtnWidth, saveBtnWidth);
    self.saveBtn = [[XHButton alloc] initWithFrame:btnRect];
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
