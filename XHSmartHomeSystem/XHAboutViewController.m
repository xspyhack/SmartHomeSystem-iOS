//
//  XHAboutViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/28/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHAboutViewController.h"
#import "XHColorTools.h"
#import "XHImageView.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellArrowItem.h"

#define XHLogoViewWidthAndHeight 100

@interface XHAboutViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XHImageView *logoView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic) UIColor *themeColor;
@end

@implementation XHAboutViewController

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _themeColor = [XHColorTools themeColor];
    
    [self setupLogoView];
    [self setupAboutGroup];
    [self setupTableView];
    [self setupFooterView];
}

#pragma mark - setup

- (void)setupTableView
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230, viewWidth, viewHeight - 250) style:UITableViewStyleGrouped];
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

- (void)setupLogoView
{
    CGFloat viewWidth = self.view.frame.size.width;
    
    CGRect logoRect = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 100, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    _logoView = [[XHImageView alloc] initWithFrame:logoRect];
    _logoView.color = _themeColor;
    _logoView.progress = 0.7f;
    _logoView.imageName = @"logo";
    _logoView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [_logoView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:_logoView];
}

- (void)setupFooterView
{
    CGRect rect = CGRectMake((self.view.frame.size.width - 200)/2, self.view.frame.size.height - 50, 200, 50);
    UILabel *version = [[UILabel alloc] initWithFrame:rect];
    version.textAlignment = NSTextAlignmentCenter;
    version.text = @"v1.1";
    [self.view addSubview:version];
}

#pragma mark - set group cell

- (void)setupAboutGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *rateItem = [XHTableViewCellArrowItem itemWithTitle:@"Rate XHSmartHomeSystem"];
    XHTableViewCellArrowItem *aboutItem = [XHTableViewCellArrowItem itemWithTitle:@"About XHSmartHomeSystem"];
    XHTableViewCellArrowItem *feedbackItem = [XHTableViewCellArrowItem itemWithTitle:@"Feedback"];
    XHTableViewCellArrowItem *helpItem = [XHTableViewCellArrowItem itemWithTitle:@"Help"];
    
    group.items = @[rateItem, aboutItem, feedbackItem, helpItem];
}

#pragma mark - private methods

- (void)tapLogoView:(UITapGestureRecognizer *)gesture
{
    XHLog(@"tap");
}

#pragma mark - tableView delegate & datasource

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
    if (item.destViewContorller) {
        UIViewController *destVC = [[item.destViewContorller alloc] init];
        destVC.title = item.title;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
    // has it method that needs to be call.
    if (item.operation) {
        item.operation();
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f]; // deselect
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
