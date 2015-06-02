//
//  XHStatusBarTipsWindow.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 6/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHStatusBarTipsWindow.h"

@interface XHStatusBarTipsWindow ()

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSTimer *hideTimer;

@end

@implementation XHStatusBarTipsWindow

+ (XHStatusBarTipsWindow *)shareTipsWindow
{
    static XHStatusBarTipsWindow *shareTipsWindow = nil;
    static dispatch_once_t onceToken;
    // singleton
    dispatch_once(&onceToken, ^{
        shareTipsWindow = [[self alloc] init];
    });
    
    return shareTipsWindow;
}

- (id)init
{
    // status bar frame
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.windowLevel = UIWindowLevelStatusBar + 10; // must larger than statusbar's window level
        self.backgroundColor = [UIColor clearColor];
        
        self.tipsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.tipsLabel.textColor = [UIColor whiteColor];
        self.tipsLabel.font = [UIFont systemFontOfSize:12];
        self.tipsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
        self.tipsLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.tipsLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateOrientation:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)updateOrientation:(NSNotification *)notification
{
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
}

- (void)showTips:(NSString *)tips
{
    if (self.hideTimer) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    }
    self.tipsLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.text = tips;
    [self makeKeyAndVisible];
    
}

- (void)showTips:(NSString *)tips hideAfterDelay:(NSInteger)seconds
{
    [self showTips:tips];
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(hideTips) userInfo:nil repeats:NO];
}

- (void)hideTips
{
    self.hidden = YES;
}

@end
