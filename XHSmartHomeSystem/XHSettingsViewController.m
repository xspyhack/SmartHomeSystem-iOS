//
//  XHSettingsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSettingsViewController.h"
#import "XHImageView.h"
#import "XHTokenModel.h"
#import "XHColorTools.h"
#import "XHTokenTools.h"
#import "XHTableViewCell.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellLabelItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHGeneralSettingsViewController.h"
#import "XHNotificationsViewController.h"
#import "XHSecurityViewController.h"
#import "XHAboutViewController.h"
#import "XHThemeViewController.h"
#import "XHLinkinViewController.h"

#define XHLogoViewWidthAndHeight 80

@interface XHSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XHImageView *logoView;
@property (nonatomic, copy) NSString *gateway;

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic) UIColor *themeColor;

@end

@implementation XHSettingsViewController

// getter & setter

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
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"settings" style:UIBarButtonItemStyleDone target:self action:@selector(settings)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"settings" highLightedImageName:@"nav_setting_highLighted" target:self action:@selector(settings)];
    
    _themeColor = [XHColorTools themeColor];
    
    [self setupData];
    [self setupTableViewCellGroup];
    [self setupTableView];
    [self setupLinkOutGroup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self moveLogoView];
}

#pragma mark - setup

- (void)setupTableView
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStyleGrouped];
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

- (void)setupData
{
    XHTokenModel *token = [XHTokenTools tokenModel];
    _gateway = token.gateway;
}

- (void)setupLogoView:(UIView *)superView
{
    CGFloat viewWidth = self.view.frame.size.width;

    CGRect logoRect = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 10, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    _logoView = [[XHImageView alloc] initWithFrame:logoRect];
    _logoView.color = _themeColor;
    _logoView.progress = 0.7f;
    _logoView.imageName = @"logo";
    _logoView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [_logoView addGestureRecognizer:tapGesture];
    
    [superView addSubview:_logoView];
}

// animation for logoview drop down
- (void)moveLogoView
{
    CGFloat viewWidth = self.view.frame.size.width;
    _logoView.frame = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, -80, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    
    NSTimeInterval animationDuration = 0.5f;
    [UIView beginAnimations:@"MoveLogoView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _logoView.frame = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 10, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    
    [UIView commitAnimations];
}

#pragma mark - set group cell

- (void)setupTableViewCellGroup
{
    // create group
    [self setupGeneralGroup]; // general, notification, security
    [self setupAboutGroup]; // about
    [self setupLinkOutGroup]; // link out, footer view button
}

- (void)setupGeneralGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *generalItem = [XHTableViewCellArrowItem itemWithTitle:@"General" iconName:@"general"];
    generalItem.destViewContorller = [XHGeneralSettingsViewController class];
    
    XHTableViewCellArrowItem *themeItem = [XHTableViewCellArrowItem itemWithTitle:@"Theme" iconName:@"general"];
    /**themeItem.operation = ^ {
        XHThemeViewController *tVC = [[XHThemeViewController alloc] init];
        [self presentViewController:tVC animated:YES completion:nil];
    };*/
    themeItem.destViewContorller = [XHThemeViewController class];
    
    XHTableViewCellArrowItem *notificationItem = [XHTableViewCellArrowItem itemWithTitle:@"Notifications" iconName:@"notification"];
    notificationItem.destViewContorller = [XHNotificationsViewController class];
    
    XHTableViewCellArrowItem *securityItem = [XHTableViewCellArrowItem itemWithTitle:@"Security" iconName:@"security"];
    securityItem.destViewContorller = [XHSecurityViewController class];
    
    group.items = @[generalItem, themeItem, notificationItem, securityItem];
}

- (void)setupAboutGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *aboutItem = [XHTableViewCellArrowItem itemWithTitle:@"About" iconName:@"about"];
    aboutItem.destViewContorller = [XHAboutViewController class];
    
    group.items = @[aboutItem];
}

- (void)setupLinkOutGroup
{
    CGRect rect = CGRectMake(0, 45, self.view.frame.size.width, 40);
    UIButton *linkout = [[UIButton alloc] initWithFrame:rect];
    linkout.backgroundColor = [XHColorTools themeColor];
    [linkout setTitle:@"Link out" forState:UIControlStateNormal];
    [linkout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [linkout addTarget:self action:@selector(linkout) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = linkout;
}

- (void)linkout
{
    NSString *msg = @"Link out will not delete any data. You can still link in with this account.";
    
    if (IOS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *linkout = [UIAlertAction actionWithTitle:@"Link out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // link out
            XHTokenModel *token = [XHTokenTools tokenModel];
            [XHTokenTools remove:token];
            
            XHLinkinViewController *linkVC = [[XHLinkinViewController alloc] init];
            [self presentViewController:linkVC animated:YES completion:nil];
            self.view.window.rootViewController = linkVC;
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:linkout];
        [alertController addAction:cancel];
        [alertController.view setTintColor:[UIColor grayColor]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *linkoutActionSheel = [[UIActionSheet alloc] initWithTitle:msg
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:@"Link out"
                                                               otherButtonTitles:nil];
        linkoutActionSheel.actionSheetStyle = UIActionSheetStyleDefault;
        
        [linkoutActionSheel showInView:self.view];
    }
}

#pragma mark - private methods

- (void)tapLogoView:(UITapGestureRecognizer *)gesture
{
    XHLog(@"tap");
    XHAboutViewController *aboutVC = [[XHAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // link out
        XHTokenModel *token = [XHTokenTools tokenModel];
        [XHTokenTools remove:token];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.backgroundColor = [UIColor whiteColor];
        window.rootViewController = [[XHLinkinViewController alloc] init];
    }
}

- (void)alert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Link out" message:@"Link out success." delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

- (void)settings
{
    XHLog(@"settings");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 193;
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 62.6, self.view.frame.size.width, 100)];
        subView.backgroundColor = _themeColor;
        
        UILabel *lbBio = [[UILabel alloc] initWithFrame:CGRectMake((subView.bounds.size.width-300)/2, 30, 300, 30)];
        lbBio.text = _gateway;
        lbBio.textColor = [UIColor whiteColor];
        lbBio.textAlignment = NSTextAlignmentCenter;
        [subView addSubview:lbBio];
        
        [view addSubview:subView];
        
        [self setupLogoView:view];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, self.view.frame.size.width, 30)];
        footView.backgroundColor = [UIColor whiteColor];
        [view addSubview:footView];
        
        return view;
    } else {
        return [[UIView alloc] init];
    }
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView alloc];
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
