//
//  XHAboutViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHAboutViewController.h"
#import "XHImageView.h"
#import "XHColorTools.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellArrowItem.h"
#import "XHAboutMeViewController.h"
#import "XHFeedbackViewController.h"
#import "XHLicenseViewController.h"

#define XHLogoViewWidthAndHeight 100

@implementation XHAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do any additional setup here.
    [self setupLogoView];
    [self setupTabelView];
    [self setupGroupItem];
    [self setupFooterView];
}

#pragma mark - setup

- (void)setupLogoView
{
    CGFloat viewWidth = self.view.frame.size.width;
    
    CGRect logoRect = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 100, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    XHImageView *logoView = [[XHImageView alloc] initWithFrame:logoRect];
    logoView.color = [XHColorTools themeColor];
    logoView.progress = 0.7f;
    logoView.imageName = @"logo-white";
    logoView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [logoView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:logoView];
}

- (void)setupTabelView
{
    CGRect rect = CGRectMake(0, 220, self.view.frame.size.width, 300);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
}

- (void)setupGroupItem
{
    self.group = [XHTableViewCellGroup group];
    
    XHTableViewCellArrowItem *rateItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Rate", nil)];
    rateItem.clicked = ^{
        NSURL *url = [NSURL URLWithString:@"https://github.com/xspyhack/SmartHomeSystem-iOS"];
        [[UIApplication sharedApplication] openURL:url];
    };
    
    XHTableViewCellArrowItem *aboutItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"About", nil)];
    aboutItem.destinationContorller = [XHAboutMeViewController class];
    
    XHTableViewCellArrowItem *feedbackItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Feedback", nil)];
    feedbackItem.destinationContorller = [XHFeedbackViewController class];
    
    XHTableViewCellArrowItem *helpItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Help", nil)];
    helpItem.clicked = ^{
        NSURL *url = [NSURL URLWithString:@"https://github.com/xspyhack/SmartHomeSystem-iOS"];
        [[UIApplication sharedApplication] openURL:url];
    };
    
    XHTableViewCellArrowItem *licenseItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"License", nil)];
    licenseItem.destinationContorller = [XHLicenseViewController class];
    
    self.group.items = @[ rateItem, aboutItem, feedbackItem, helpItem, licenseItem ];
}

- (void)setupFooterView
{
    CGRect rect = CGRectMake((self.view.frame.size.width - 200)/2, self.view.frame.size.height - 50, 200, 50);
    UILabel *version = [[UILabel alloc] initWithFrame:rect];
    version.textAlignment = NSTextAlignmentCenter;
    version.text = @"v1.1";
    version.textColor = [XHColorTools themeColor];
    [self.view addSubview:version];
}

#pragma mark

- (void)tapLogoView:(UIGestureRecognizer *)gesture
{
    XHLog(@"tap logo view");
}

@end
