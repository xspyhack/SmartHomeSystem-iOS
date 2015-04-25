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
#import "XHTableViewCellCheckmarkItem.h"
#import "XHColorTools.h"

@implementation XHTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"XHTabelViewCellIdentifier";
    XHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = XHCellBackgroundColor;
    }
    
    return cell;
}

// getter
- (UISwitch *)rightSwitch
{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch setOnTintColor:[XHColorTools themeColor]];
        //_rightSwitch.on = YES;
        [_rightSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textColor = [XHColorTools themeColor];
    }
    return _rightLabel;
}

- (void)setItem:(XHTableViewCellItem *)item
{
    _item = item;
    if (item.iconName) {
        self.imageView.image = [UIImage imageNamed:item.iconName];
    }
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
        XHTableViewCellSwitchItem *switchItem = (XHTableViewCellSwitchItem *)item; // cover
        self.rightSwitch.on = switchItem.on;
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[XHTableViewCellLabelItem class]]) {
        XHTableViewCellLabelItem *labelItem = (XHTableViewCellLabelItem *)item; // cover to labelItem
        self.rightLabel.text = labelItem.text;
        [self.rightLabel sizeToFit];
        self.accessoryView = self.rightLabel;
    } else if ([item isKindOfClass:[XHTableViewCellCheckmarkItem class]]) {
        XHTableViewCellCheckmarkItem *checkmarkItem = (XHTableViewCellCheckmarkItem *)item;
        self.accessoryType = checkmarkItem.type;
    } else {
        self.accessoryView = nil;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)switchAction
{
    if (self.item.tapSwitch) {
        self.item.tapSwitch();
    }
}

@end
