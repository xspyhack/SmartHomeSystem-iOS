//
//  XHSearchResultsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/8/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSearchResultsViewController.h"
#import "XHMessageTools.h"

@interface XHSearchResultsViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchDataSource;

@end

@implementation XHSearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.searchDataSource addObjectsFromArray:self.dataSource];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchDataSource || self.searchDataSource.count == 0) {
        self.searchDataSource = self.dataSource;
    }
    return self.searchDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchResultsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = XHCellBackgroundColor;
        //cell.tintColor = [XHColorTools themeColor];
    }
    //NSDictionary *dict = self.searchDataSource[indexPath.row];
    cell.textLabel.text = self.searchDataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        return;
    }
    
    // first empty data source
//    if (self.searchDataSource) {
//        [self.searchDataSource removeAllObjects];
//    }
    
    // get search string
    NSString *searchString = [searchController.searchBar text];
    // set predicate
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchString];
    self.searchDataSource = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:filterPredicate]];
    [self.tableView reloadData];
}

#pragma mark - Property Overrides

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (NSDictionary *dict in [XHMessageTools messages]) {
            [_dataSource addObject:dict[@"strContent"]];
        }
    }
    return _dataSource;
}

@end
