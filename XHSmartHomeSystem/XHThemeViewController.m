//
//  XHThemeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/24/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHThemeViewController.h"
#import "XHColorsView.h"

#define XHColorsViewHeight (self.view.frame.size.width + 10)

@interface XHThemeViewController ()

@property (nonatomic, strong) XHColorsView *colorsView;

@end

@implementation XHThemeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupColorsView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XHThemeDidChangeNotification object:self];
    });
}

#pragma mark - setup methods

- (void)setupColorsView
{
    CGRect rect = CGRectMake(0, 140, self.view.frame.size.width, XHColorsViewHeight);
    self.colorsView = [[XHColorsView alloc] initWithFrame:rect];
    self.colorsView.master = @"XHThemeColor";
    //[self.colorsView pullDown:1.0];

    [self.view addSubview:self.colorsView];
}

@end
