//
//  XHMessagesViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessagesViewController.h"
#import "UUMessage.h"
#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "XHMessageModel.h"
#import "XHMessageSettingViewController.h"
#import "XHSearchResultsViewController.h"
#import "XHChatInfoViewController.h"
#import "SVPullToRefresh.h"

#define XHTableViewScrollToBottom (@"XHTableViewScrollToBottom")
@interface XHMessagesViewController ()<UISearchBarDelegate, UUMessageCellDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchController *navItemSearchController;
@property (nonatomic, strong) UIView *searchBarView;
@end

@implementation XHMessagesViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone; // iOS_7_LATER, it should set edges NO.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarItem.badgeValue = nil;
    
    // set navigation bar button item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_settings" highLightedImageName:@"nav_settings_highLighted" target:self action:@selector(settings)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_search" highLightedImageName:@"nav_search_highLighted" target:self action:@selector(searchButtonClicked)];
    
    [self setupTabelView];
    //[self setupSearchController];
    [self setupData];
    
    // setup pull to refresh
    __weak XHMessagesViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowsAtTop];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlertNotification:) name:XHDidAlertNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClearNotification:) name:XHClearMessagesNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScrollToBottom) name:XHTableViewScrollToBottom object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarItem.badgeValue = nil;
    
    //XHLocate();
    [[NSNotificationCenter defaultCenter] postNotificationName:XHTableViewScrollToBottom object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XHTableViewScrollToBottom object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setup method

- (void)setupTabelView
{
    // create Plain style UITableView
    CGRect frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 109); // tabBar height: 49
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupData
{
    self.messageModel = [[XHMessageModel alloc] init];
    [self.messageModel populateDataSource];
    
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)setupSearchController
{
    XHSearchResultsViewController *searchResultsController = [[XHSearchResultsViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = searchResultsController;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:.8];
    
    [self.searchBarView addSubview:self.searchController.searchBar];
   
    //self.searchController.searchBar.layer.borderWidth = 0;
    [self.searchController.searchBar sizeToFit];
    
    self.definesPresentationContext = YES;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHMessageCellID"];
    if (!cell) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XHMessageCellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.messageModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchController setActive:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController setActive:NO];
}

#pragma mark - UUMessageCellDelegate

- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    XHChatInfoViewController *chatInfoVC = [[XHChatInfoViewController alloc] init];
    chatInfoVC.name = cell.messageFrame.message.strName;
    chatInfoVC.profileImageName = cell.messageFrame.message.strIcon;
    
    [self.navigationController pushViewController:chatInfoVC animated:YES];
}

#pragma mark - Notifications

- (void)handleAlertNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:XHDidAlertNotification]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
        [dict setObject:dict[@"strName"] forKey:@"strIcon"];
        
        [self.messageModel addMessageItem:dict];
        [self.tableView reloadData];
        //[self tableViewScrollToBottom];
        if (self.tabBarItem.badgeValue) {
            NSInteger badge = [self.tabBarItem.badgeValue integerValue];
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badge + 1];
        } else {
            self.tabBarItem.badgeValue = @"1";
        }
    }
}

- (void)handleClearNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:XHClearMessagesNotification]) {
        [self.messageModel removeDataSource];
        self.messageModel = nil;
        [self.tableView reloadData];
    }
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.messageModel.dataSource.count == 0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageModel.dataSource.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - private methods

- (void)insertRowsAtTop
{
    __weak XHMessagesViewController *weakSelf = self;
    int64_t delayInSecond = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecond * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSUInteger count = [weakSelf.messageModel insertDataSourceWithNumber:10];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void)searchButtonClicked
{
    // Create the search results view controller and use it for the UISearchController.
    XHSearchResultsViewController *resultsController = [[XHSearchResultsViewController alloc] init];
    
    // Create the search controller and make it perform the results updating.
    self.navItemSearchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    self.navItemSearchController.searchResultsUpdater = resultsController;
    self.navItemSearchController.hidesNavigationBarDuringPresentation = NO;
    self.navItemSearchController.searchBar.barTintColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:.8];
    
    self.definesPresentationContext = NO;
    // Present the view controller.
    [self presentViewController:self.navItemSearchController animated:YES completion:nil];
}

- (void)settings
{
    XHMessageSettingViewController *settingVC = [[XHMessageSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)searchBarView
{
    if (!_searchBarView) {
        _searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 44)];
        [self.view addSubview:_searchBarView];
    }
    return _searchBarView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
