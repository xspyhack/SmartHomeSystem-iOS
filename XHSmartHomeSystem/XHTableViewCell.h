//
//  XHTableViewCell.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHTableViewCellItem;

@interface XHTableViewCell : UITableViewCell

@property (nonatomic, strong) XHTableViewCellItem *item;
@property (nonatomic, strong) UISwitch *rightSwitch;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
