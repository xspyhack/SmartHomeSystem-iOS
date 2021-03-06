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

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"settings" style:UIBarButtonItemStyleDone target:self action:@selector(settings)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"settings" highLightedImageName:@"nav_setting_highLighted" target:self action:@selector(settingsButtonItemClicked)];
    
    self.themeColor = [XHColorTools themeColor];
    
    [self setupData];
    [self setupTableViewCellGroup];
    [self setupTableView];
    [self setupLinkOutGroup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self dropLogoView];
}

#pragma mark - setup

- (void)setupTableView
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStyleGrouped];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    self.tableView.showsVerticalScrollIndicator = NO; // don't show vertical scroll
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setupData
{
    XHTokenModel *token = [XHTokenTools tokenModel];
    self.gateway = token.gateway;
}

- (void)setupLogoViewWithSuperView:(UIView *)superView
{
    CGFloat viewWidth = self.view.frame.size.width;

    CGRect logoRect = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 10, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    self.logoView = [[XHImageView alloc] initWithFrame:logoRect];
    self.logoView.color = self.themeColor;
    self.logoView.progress = 0.7f;
    self.logoView.imageName = @"logo-white";
    self.logoView.userInteractionEnabled = YES; // must set user interaction enable
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoView:)];
    [self.logoView addGestureRecognizer:tapGesture];
    
    [superView addSubview:self.logoView];
}

// animation for logoview drop down
- (void)dropLogoView
{
    CGFloat viewWidth = self.view.frame.size.width;
    self.logoView.frame = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, -80, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    
    // this method had be discouraged but not deprecated although, it should use block
    /*
    NSTimeInterval animationDuration = 0.5f;
    [UIView beginAnimations:@"MoveLogoView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _logoView.frame = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 10, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    
    [UIView commitAnimations];
    */
    
    // use block
    [UIView animateWithDuration:0.5f animations:^{
        self.logoView.frame = CGRectMake((viewWidth - XHLogoViewWidthAndHeight)/2, 10, XHLogoViewWidthAndHeight, XHLogoViewWidthAndHeight);
    }];
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
    
    XHTableViewCellArrowItem *generalItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"General", nil) iconName:@"settings_general"];
    generalItem.destinationContorller = [XHGeneralSettingsViewController class];
    
    XHTableViewCellArrowItem *themeItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Theme", nil) iconName:@"settings_theme"];
    /**themeItem.operation = ^{
        XHThemeViewController *tVC = [[XHThemeViewController alloc] init];
        [self presentViewController:tVC animated:YES completion:nil];
    };*/
    themeItem.destinationContorller = [XHThemeViewController class];
    
    XHTableViewCellArrowItem *notificationItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Notifications", nil) iconName:@"settings_notifications"];
    notificationItem.destinationContorller = [XHNotificationsViewController class];
    
    XHTableViewCellArrowItem *securityItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Security", nil) iconName:@"settings_security"];
    securityItem.destinationContorller = [XHSecurityViewController class];
    
    group.items = @[generalItem, themeItem, notificationItem, securityItem];
}

- (void)setupAboutGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *aboutItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"About", nil) iconName:@"settings_about"];
    aboutItem.destinationContorller = [XHAboutViewController class];
    
    group.items = @[ aboutItem ];
}

- (void)setupLinkOutGroup
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    UIButton *linkout = [[UIButton alloc] initWithFrame:rect];
    linkout.backgroundColor = [_themeColor colorWithAlphaComponent:.8f];
    [linkout setTitle:NSLocalizedString(@"Link Out", nil) forState:UIControlStateNormal];
    [linkout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [linkout addTarget:self action:@selector(linkout) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = linkout;
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
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50; // default 44
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 193;
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 62.6, self.view.frame.size.width, 100)];
        subView.backgroundColor = [_themeColor colorWithAlphaComponent:.8f];
        
        UILabel *lbBio = [[UILabel alloc] initWithFrame:CGRectMake((subView.bounds.size.width-300)/2, 30, 300, 30)];
        lbBio.text = _gateway;
        lbBio.textColor = [UIColor whiteColor];
        lbBio.textAlignment = NSTextAlignmentCenter;
        [subView addSubview:lbBio];
        
        [view addSubview:subView];
        
        [self setupLogoViewWithSuperView:view];
        
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
    if (item.destinationContorller) {
        UIViewController *destVC = [[item.destinationContorller alloc] init];
        destVC.title = item.title;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
    // has it method that needs to be call.
    if (item.clicked) {
        item.clicked();
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f]; // deselect
}

#pragma mark - UIActionSheetDelegate

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

#pragma mark - event

- (void)tapLogoView:(UITapGestureRecognizer *)gesture
{
    XHLog(@"tap");
    XHAboutViewController *aboutVC = [[XHAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)linkout
{
    NSString *msg = NSLocalizedString(@"Link out will not delete any data. You can still link in with this account.", nil);
    
    if (IOS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *linkout = [UIAlertAction actionWithTitle:NSLocalizedString(@"Link Out", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // link out
            XHTokenModel *token = [XHTokenTools tokenModel];
            [XHTokenTools remove:token];
            
            //XHLinkinViewController *linkVC = [[XHLinkinViewController alloc] init];
            //[self presentViewController:linkVC animated:YES completion:nil];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.backgroundColor = [UIColor whiteColor];
            window.rootViewController = [[XHLinkinViewController alloc] init];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:linkout];
        [alertController addAction:cancel];
        [alertController.view setTintColor:[UIColor grayColor]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *linkoutActionSheel = [[UIActionSheet alloc] initWithTitle:msg
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                          destructiveButtonTitle:NSLocalizedString(@"Link Out", nil)
                                                               otherButtonTitles:nil];
        linkoutActionSheel.actionSheetStyle = UIActionSheetStyleDefault;
        
        [linkoutActionSheel showInView:self.view];
    }
}

- (void)settingsButtonItemClicked
{
    XHLog(@"settings");
}

#pragma mark - private methods

//- (void)alert
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Link Out", nil) message:NSLocalizedString(@"Link out success.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
//    [alert show];
//}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
