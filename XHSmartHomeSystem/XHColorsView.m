//
//  XHColorsView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/24/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHColorsView.h"
#import "XHColorModel.h"
#import "MBProgressHUD.h"
#import "XHButton.h"

#define XHColorBtnWidth 44
#define XHColorsViewHeight 370

@interface XHColorsView ()
@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *lastButton;
@end

@implementation XHColorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pull = NO; // can not pull down & pull up default.
        [self setupColors];
        [self setupButton];
    }
    return self;
}

- (void)setMaster:(NSString *)master
{
    _master = master;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [defaults integerForKey:_master];
    self.backgroundColor = [[XHColorModel colorModelWithIndex:index] colorWithAlphaComponent:0.85];
}

- (void)setupColors
{
    self.colorsArray = [NSMutableArray array];
    for (NSInteger index = 0; index < XHColorCount; index++) {
        UIColor *color= [XHColorModel colorModelWithIndex:index];
        [self.colorsArray addObject:color];
    }
}

- (void)setupButton
{
    for (NSInteger index = 0; index < XHColorCount; index++) {
        UIColor *color = [self.colorsArray objectAtIndex:index];
        NSInteger row = index % 5;
        NSInteger line = index / 5;
        CGRect rect = CGRectMake((row * XHColorBtnWidth * 1.5) + 33.5, 33.5 + (line * XHColorBtnWidth * 1.5), XHColorBtnWidth, XHColorBtnWidth);
        [self setupColorsWithColor:color frame:rect tap:index];
        //[self.btnArray objectAtIndex:index];
    }
    
    CGRect btnRect = CGRectMake((self.frame.size.width - 50)/2, self.frame.size.height - 70, 50, 50);
    XHButton *saveBtn = [[XHButton alloc] initWithFrame:btnRect];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self addSubview:saveBtn];
}

- (void)setupColorsWithColor:(UIColor *)color frame:(CGRect)frame tap:(NSInteger)index
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = color;
    btn.tag = index;
    btn.layer.shadowOpacity = 0;
    btn.layer.cornerRadius = btn.frame.size.width/2;
    [btn addTarget:self action:@selector(pickupColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}

- (void)pickupColor:(UIButton *)btn
{
    NSInteger index = btn.tag;
    
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 0);
    btn.layer.shadowRadius = 3.0f;
    btn.layer.shadowOpacity = 0.9;
    self.lastButton.layer.shadowOpacity = 0;
    self.lastButton = btn;
    
    UIColor *color = [self.colorsArray objectAtIndex:index];
    self.backgroundColor = [color colorWithAlphaComponent:0.9];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:index forKey:self.master];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pullUp) userInfo:nil repeats:NO];
    } else {
        if ([self.timer isValid]) {
            [self.timer invalidate]; // reset timer
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pullUp) userInfo:nil repeats:NO];
        }
    }
    
}

- (void)pullDown:(NSTimeInterval)animationDuration
{
    [UIView beginAnimations:@"PullDownLogoView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, 90, self.frame.size.width, XHColorsViewHeight);
    //self.colorsView.center = self.view.center;
    
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
        self.frame = CGRectMake(0, -XHColorsViewHeight - 60, self.frame.size.width, XHColorsViewHeight);
        //self.colorsView.center = self.view.center;
        
        [UIView commitAnimations];
    }
}

- (void)save
{
    if (self.pull) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL flag = [defaults boolForKey:@"XHHaveColorObserver"];
        if (flag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XHColorDidChangeNotification object:self];
        }
        [self pullUp];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Save";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
    }
}

@end
