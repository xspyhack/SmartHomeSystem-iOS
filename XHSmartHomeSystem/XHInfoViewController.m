//
//  XHInfoViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHInfoViewController.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"

@interface XHInfoViewController ()

@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation XHInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate & UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XHTableViewCellGroup *group = self.groups[section];
    return group.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHTableViewCell *cell = [XHTableViewCell cellWithTableView:tableView];
    XHTableViewCellGroup *group = self.groups[indexPath.section];
    XHTableViewCellItem *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHTableViewCellGroup *group = self.groups[indexPath.section];
    XHTableViewCellItem *item = group.items[indexPath.row];
    if (item.destinationContorller) {
        UIViewController *destinationController = [[item.destinationContorller alloc] init];
        destinationController.title = item.title;
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
    // has it method that needs to be call.
    if (item.clicked) {
        item.clicked();
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f]; // deselect
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - getter & setter

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [_tableView setSeparatorColor:[UIColor whiteColor]];
    _tableView.showsVerticalScrollIndicator = NO; // don't show vertical scroll
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)setGroup:(XHTableViewCellGroup *)group
{
    _group = group;
    [self.groups addObject:group];
}

@end
