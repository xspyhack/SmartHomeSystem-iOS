//
//  XHTableViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTableViewController.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellCheckmarkItem.h"

@interface XHTableViewController ()

@property (nonatomic, copy) NSIndexPath *checkIndexPath;

@end

@implementation XHTableViewController

#pragma mark - life cycle

// forbid set UITableViewStyle
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    
    // no dispaly vertical scroll idicator
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XHTableViewCellGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHTableViewCell *cell = [XHTableViewCell cellWithTableView:tableView];
    XHTableViewCellGroup *group = self.groups[indexPath.section];
    XHTableViewCellItem *item = group.items[indexPath.row];
    
    // this is very important.
    // it will read user default setting first, and then get last time which item had been checkmark.
    // it will alloc tableview cell by call this method when this view didLoad.
    // so, we can set _checkIndexPath with last checkmark item before did select item.
    // if not, the _checkIndexPath is nil because it is a private variable.
    // and it will cause problem in didSelect method.
    if ([item isKindOfClass:[XHTableViewCellCheckmarkItem class]]) {
        XHTableViewCellCheckmarkItem *checkItem = (XHTableViewCellCheckmarkItem *)item;
        if (checkItem.type == UITableViewCellAccessoryCheckmark) {
            self.checkIndexPath = indexPath;
        }
    }
    cell.item = item;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    XHTableViewCellGroup *group = self.groups[section];
    return group.groupHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    XHTableViewCellGroup *group = self.groups[section];
    return group.groupFooter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHTableViewCellGroup *group = self.groups[indexPath.section];
    XHTableViewCellItem *item = group.items[indexPath.row];
    if (item.destViewContorller) {
        UIViewController *destVC = [[item.destViewContorller alloc] init];
        destVC.title = item.title;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
    // does this item have operation block method that needs to be call.
    if (item.operation) {
        item.operation();
    }
    
    // deal checkmark
    // it must set _checkIndexPath when alloc cell.
    if ([item isKindOfClass:[XHTableViewCellCheckmarkItem class]]) {
        if (self.checkIndexPath) {
            if ([self.checkIndexPath isEqual:indexPath]) {
                return;
            }
            XHTableViewCell *uncheckCell = (XHTableViewCell *)[tableView cellForRowAtIndexPath:self.checkIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        XHTableViewCell *cell = (XHTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkIndexPath = indexPath;
    }
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f]; // delay to deselect
}

// deselect alter 0.5s
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - getter

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

@end
