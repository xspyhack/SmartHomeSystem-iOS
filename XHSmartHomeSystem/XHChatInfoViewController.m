//
//  XHChatInfoViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHChatInfoViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHImageView.h"
#import "XHColorTools.h"

#define XHAvatarWidth 80

@implementation XHChatInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupProfileView];
    [self setupGroupItem];
    [self setupTableView];
    [self setupFooterView];
}

#pragma mark - setup

- (void)setupTableView
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, viewWidth, viewHeight - 250) style:UITableViewStyleGrouped];
}

- (void)setupGroupItem
{
    self.group = [XHTableViewCellGroup group];
    
    XHTableViewCellSwitchItem *stickItem = [XHTableViewCellSwitchItem itemWithTitle:@"Stick to top"];
    XHTableViewCellSwitchItem *shieldItem = [XHTableViewCellSwitchItem itemWithTitle:@"Shield"];
    
    self.group.items = @[stickItem, shieldItem];
}

- (void)setupProfileView
{
    CGFloat viewWidth = self.view.frame.size.width;
    UIColor *color = [XHColorTools themeColor];
    
    CGRect avatarRect = CGRectMake((viewWidth - XHAvatarWidth)/2, 100, XHAvatarWidth, XHAvatarWidth);
    XHImageView *avatarView = [[XHImageView alloc] initWithFrame:avatarRect];
    avatarView.color = color;
    avatarView.progress = 0.7f;
    avatarView.imageName = self.profileImageName;
    avatarView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [avatarView addGestureRecognizer:tapGesture];
    
    CGRect nameRect = CGRectMake((viewWidth - 200)/2, CGRectGetMaxY(avatarRect)+20, 200, 20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameRect];
    nameLabel.text = self.name;
    nameLabel.textColor = color;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect bioRect = CGRectMake((viewWidth - 200)/2, CGRectGetMaxY(nameRect)+10, 200, 20);
    UILabel *bioLabel = [[UILabel alloc] initWithFrame:bioRect];
    bioLabel.text = @"Bio: nothing else.";
    bioLabel.textColor = color;
    bioLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:avatarView];
    [self.view addSubview:nameLabel];
    [self.view addSubview:bioLabel];
}

- (void)setupFooterView
{
    CGRect rect = CGRectMake(0, 45, self.view.frame.size.width, 40);
    UIButton *block = [[UIButton alloc] initWithFrame:rect];
    block.backgroundColor = [XHColorTools themeColor];
    [block setTitle:@"Block" forState:UIControlStateNormal];
    [block setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [block addTarget:self action:@selector(block) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = block;
}

#pragma mark - private methods

- (void)tapLogoView:(UITapGestureRecognizer *)gesture
{
    XHLog(@"tap");
}

- (void)block
{
    XHLog(@"block");
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30; // here is only one section, so we can just return 30.
}

@end
