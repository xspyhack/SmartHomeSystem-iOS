//
//  XHTableViewCell.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTableViewCell.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellLabelItem.h"

@implementation XHTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"XHTabelViewCellIdentifier";
    XHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = XHColor(245, 245, 245);
    }
    
    return cell;
}

// getter
- (UISwitch *)rightSwitch
{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch setOnTintColor:[UIColor redColor]];
        _rightSwitch.on = YES;
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textColor = XHOrangeColor;
    }
    return _rightLabel;
}

- (void)setItem:(XHTableViewCellItem *)item
{
    _item = item;
    self.imageView.image = [UIImage imageNamed:item.iconName];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.detail;
    
    // this method call very busy, so it should not write like this.
    /*
    if ([item isKindOfClass:[XHTableViewCellArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([item isKindOfClass:[XHTableViewCellSwitchItem class]]) {
        self.accessoryView = [[UISwitch alloc] init];
    } else {
        self.accessoryView = nil;
    }
     */
    if ([item isKindOfClass:[XHTableViewCellArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([item isKindOfClass:[XHTableViewCellSwitchItem class]]) {
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[XHTableViewCellLabelItem class]]) {
        self.accessoryView = self.rightLabel;
    } else {
        self.accessoryView = nil;
    }
}

@end
