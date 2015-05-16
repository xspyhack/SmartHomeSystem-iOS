//
//  XHCmdLineViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/4/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHCmdLineViewController.h"
#import "XHColorTools.h"
#import "XHSocketThread.h"

@interface XHCmdLineViewController ()<UITextViewDelegate, XHSocketThreadDelegate>

@property (nonatomic, strong) UITextView *statusView;

@end

@implementation XHCmdLineViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    [self.view addGestureRecognizer:longPressGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self.view addGestureRecognizer:swipeGesture];
    
    [self setupTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XHSocketThread shareInstance].delegate = self;
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

- (void)didReadBuffer:(NSString *)buffer
{
    [self addStatusText:buffer];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self addStatusText:@"\n$ "];
}

#pragma mark - event response

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender
{
    [self.statusView resignFirstResponder];
}

#pragma mark - private methods

- (void)addStatusText:(NSString *)text
{
    self.statusView.text = [self.statusView.text stringByAppendingString:text];
}

@end
