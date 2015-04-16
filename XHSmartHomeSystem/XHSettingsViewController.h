//
//  XHSettingsViewController.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHImageView;

@interface XHSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XHImageView *logoView;
@property (nonatomic, copy) NSString *gateway;

@property (nonatomic, strong) NSMutableArray *groups;

@end
