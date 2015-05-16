//
//  XHGatewayViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGatewayViewController.h"
#import "XHInputView.h"
#import "XHTokenModel.h"
#import "XHTokenTools.h"

@interface XHGatewayViewController ()

@property (nonatomic, strong) XHInputView *gatewayView;
@property (nonatomic, strong) XHInputView *passwordView;

@end

@implementation XHGatewayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSMutableDictionary *tokenDict = [NSMutableDictionary dictionary];
    [tokenDict setObject:self.gatewayView.value.text forKey:@"gateway"];
    [tokenDict setObject:self.passwordView.value.text forKey:@"password"];
    [tokenDict setObject:[NSDate distantFuture] forKey:@"expires_time"];
    XHTokenModel *token = [XHTokenModel tokenModelWithDictionary:tokenDict];
    [XHTokenTools save:token];
}

#pragma mark - setup view

- (void)setupSubView
{
    NSString *gateway = [XHTokenTools tokenModel].gateway;
    NSString *password = [XHTokenTools tokenModel].password;
    
    CGRect hostRect = CGRectMake(0, 100, self.view.frame.size.width, 43);
    self.gatewayView = [[XHInputView alloc] initWithFrame:hostRect];
    self.gatewayView.label.text = @"Gateway";
    self.gatewayView.value.text = gateway;
    
    CGRect portRect = CGRectMake(0, CGRectGetMaxY(hostRect), self.view.frame.size.width, 43);
    self.passwordView = [[XHInputView alloc] initWithFrame:portRect];
    self.passwordView.label.text = @"Password";
    self.passwordView.value.secureTextEntry = YES;
    self.passwordView.value.text = password;
    
    [self.view addSubview:self.gatewayView];
    [self.view addSubview:self.passwordView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.gatewayView.value resignFirstResponder];
    [self.passwordView.value resignFirstResponder];
}

@end
