//
//  XHSplashView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/29/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSplashView.h"
#import "XHColorTools.h"
#import "XHImageView.h"
#import "MultiplePulsingHaloLayer.h"

#define XHLogoViewWidthAndHeight 100

@interface XHSplashView ()
@property (nonatomic, strong) XHImageView *logoView;
@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHalo;
@end

@implementation XHSplashView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupLogoView];
    }
    return self;
}

- (void)setupLogoView
{
    //CGFloat viewWidth = self.view.frame.size.width;
    
    CGRect logoRect = CGRectMake(0, 0, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    self.logoView = [[XHImageView alloc] initWithFrame:logoRect];
    self.logoView.color = [XHColorTools themeColor];
    self.logoView.progress = 0.7f;
    self.logoView.imageName = @"logo-white";
    [self addSubview:self.logoView];
    self.logoView.center = self.center;
    
    [self.layer insertSublayer:self.mutiHalo below:self.logoView.layer];
}

- (void)remove
{
    [UIView animateWithDuration:.5f
                     animations:^{
                         [self.logoView setFrame:CGRectMake(self.logoView.center.x, self.logoView.center.y, 0, 0)];
                         self.logoView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.logoView removeFromSuperview];
                     }];
}

- (MultiplePulsingHaloLayer *)mutiHalo
{
    if (!_mutiHalo) {
        _mutiHalo = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
        _mutiHalo.position = self.logoView.center;
        _mutiHalo.useTimingFunction = NO;
        [_mutiHalo buildSublayers];
        _mutiHalo.radius = 200;
        [_mutiHalo setHaloLayerColor:[XHColorTools themeColor].CGColor];
    }
    return _mutiHalo;
}


@end
