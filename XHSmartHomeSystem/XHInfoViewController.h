//
//  XHInfoViewController.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHTableViewCellGroup;

@interface XHInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XHTableViewCellGroup *group;

@end
