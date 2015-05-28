//
//  XHLicenseViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/28/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLicenseViewController.h"

@interface XHLicenseViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end;


@implementation XHLicenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupWebView];
}

- (void)setupWebView
{
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    [self.webView loadRequest:request];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return _webView;
}

@end
