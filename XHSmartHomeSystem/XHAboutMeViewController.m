//
//  XHAboutMeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/28/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHAboutMeViewController.h"
#import "XHImageView.h"
#import "XHColorTools.h"
#import "MultiplePulsingHaloLayer.h"

#define XHLogoViewWidthAndHeight 100

@interface XHAboutMeViewController ()
@property (nonatomic, strong) XHImageView *logoView;
@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHalo;
@end

@implementation XHAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLogoView];
}

- (void)setupLogoView
{
    //CGFloat viewWidth = self.view.frame.size.width;
    
    CGRect logoRect = CGRectMake(0, 0, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    self.logoView = [[XHImageView alloc] initWithFrame:logoRect];
    self.logoView.color = [XHColorTools themeColor];
    self.logoView.progress = 0.7f;
    self.logoView.imageName = @"logo-white";
    self.logoView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [self.logoView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.logoView];
    self.logoView.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view.layer insertSublayer:self.mutiHalo below:self.logoView.layer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    baseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    baseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, .0, .0, 1.0)];
    baseAnimation.duration = .5f;
    baseAnimation.cumulative = YES;
    baseAnimation.repeatCount = 100;
    
    [self.logoView.layer addAnimation:baseAnimation forKey:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.logoView.layer removeAllAnimations];
    
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

- (void)tapLogoView:(UIGestureRecognizer *)gesture
{
    XHLog(@"tap logo view");
}

@end
