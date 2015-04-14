//
//  XHHomeViewController.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *modelCells;
@property (nonatomic, copy) NSMutableArray *model;

@end
