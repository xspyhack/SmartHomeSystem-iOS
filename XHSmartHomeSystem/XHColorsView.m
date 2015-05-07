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

#define XHColorsViewHeight (self.frame.size.width + 10)
#define XHColorBtnWidht (self.frame.size.width / 8.0)

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
    //CGFloat spaceWidht = self.frame.size.width * 33.5 / 375.0;
    CGFloat btnWidth = self.frame.size.width / 8.0;
    for (NSInteger index = 0; index < XHColorCount; index++) {
        UIColor *color = [self.colorsArray objectAtIndex:index];
        NSInteger column = index % 5;
        NSInteger row = index / 5;
        CGRect rect = CGRectMake((column * btnWidth * 1.5) + btnWidth/2, btnWidth/2 + (row * btnWidth * 1.5), btnWidth, btnWidth);
        [self setupColorsWithColor:color frame:rect tap:index];
        //[self.btnArray objectAtIndex:index];
    }
    
    CGFloat saveBtnWidth = self.frame.size.width / 6.4;
    CGRect btnRect = CGRectMake((self.frame.size.width - saveBtnWidth)/2, self.frame.size.height -saveBtnWidth - btnWidth/2, saveBtnWidth, saveBtnWidth);
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
    // this method had be discouraged, but not be deprecated, it should use block to instead
    /*
    [UIView beginAnimations:@"PullDownColorsView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, 90, self.frame.size.width, XHColorsViewHeight);
    //self.colorsView.center = self.view.center;
    
    [UIView commitAnimations];
    */
    
    // use block
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, 90, self.frame.size.width, XHColorsViewHeight);
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
        [UIView beginAnimations:@"PullUpColorsView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = CGRectMake(0, -XHColorsViewHeight-66, self.frame.size.width, XHColorsViewHeight);
        //self.colorsView.center = self.view.center;
        [UIView commitAnimations];
        */
        
        // use block
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(0, -XHColorsViewHeight-66, self.frame.size.width, XHColorsViewHeight);
        }];
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
        
        [hud hide:YES afterDelay:2];
    }
}

- (void)setMaster:(NSString *)master
{
    _master = master;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [defaults integerForKey:_master];
    self.backgroundColor = [[XHColorModel colorModelWithIndex:index] colorWithAlphaComponent:0.85];
}


@end
