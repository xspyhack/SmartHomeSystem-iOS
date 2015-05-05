//
//  XHCmdLineViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/4/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHCmdLineViewController.h"
#import "XHColorTools.h"

@interface XHCmdLineViewController ()

@property (nonatomic, strong) UITextView *statusView;

@end

@implementation XHCmdLineViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    [self.view addGestureRecognizer:longPressGesture];
    
    [self setupTextView];
}

#pragma mark - setup

- (void)setupTextView
{
    CGRect rect = CGRectMake(0, 22, self.view.frame.size.width, 600);
    self.statusView = [[UITextView alloc] initWithFrame:rect];
    self.statusView.textColor = [XHColorTools themeColor];
    self.statusView.backgroundColor = [UIColor blackColor];
    self.statusView.textAlignment = NSTextAlignmentLeft;
    self.statusView.text = @"Last login: Mon May  4 18:37:57 on ttys002\n";
    [self addStatusText:@"$ "];
    
    [self.view addSubview:self.statusView];
}

#pragma mark - delegate

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - event response

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods

- (void)addStatusText:(NSString *)text
{
    self.statusView.text = [self.statusView.text stringByAppendingString:text];
}

@end
