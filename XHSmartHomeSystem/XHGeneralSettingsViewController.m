//
//  XHGeneralSettingsViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGeneralSettingsViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHGatewayViewController.h"
#import "XHDisplayViewController.h"
#import "XHFeaturesViewController.h"
#import "XHLanguageViewController.h"
#import "XHColorTools.h"

@interface XHGeneralSettingsViewController ()

@property(nonatomic, strong) XHTableViewCellArrowItem *languageItem;

@end

@implementation XHGeneralSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGeneralGroup];
    [self setupLanguageGroup];
    [self setupWipeCacheGroup];
}

#pragma mark - private methods

- (void)setupGeneralGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *gatewayItem = [XHTableViewCellArrowItem itemWithTitle:@"Gateway"];
    gatewayItem.destinationContorller = [XHGatewayViewController class];
    
    XHTableViewCellArrowItem *displayItem = [XHTableViewCellArrowItem itemWithTitle:@"Display"];
    displayItem.destinationContorller = [XHDisplayViewController class];
    
    XHTableViewCellArrowItem *featureItem = [XHTableViewCellArrowItem itemWithTitle:@"Features"];
    featureItem.destinationContorller = [XHFeaturesViewController class];
    
    group.items = @[ gatewayItem, displayItem, featureItem ];
}

- (void)setupLanguageGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    self.languageItem = [XHTableViewCellArrowItem itemWithTitle:@"Language"];
    self.languageItem.destinationContorller = [XHLanguageViewController class];
    
    group.items = @[ self.languageItem ];
}

- (void)setupWipeCacheGroup
{
    CGRect rect = CGRectMake(0, 15, self.view.frame.size.width, 40);
    UIButton *wipeCacheButton = [[UIButton alloc] initWithFrame:rect];
    wipeCacheButton.backgroundColor = [XHColorTools themeColor];
    [wipeCacheButton setTitle:@"Wipe Cache Partition" forState:UIControlStateNormal];
    [wipeCacheButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wipeCacheButton addTarget:self action:@selector(wipeCacheButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = wipeCacheButton;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wipe cache" message:@"Wipe cache partition success." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    // cancel
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.groups count] - 1) {
        return 30;
    }
    return 15; // default height
}

#pragma mark - event response

- (void)wipeCacheButtonClicked
{
    NSString *msg = @"It will wipe all your cache.";
    
    if (IOS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *wipeCache = [UIAlertAction actionWithTitle:@"Wipe" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // link out
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:wipeCache];
        [alertController addAction:cancel];
        [alertController.view setTintColor:[UIColor grayColor]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *linkoutActionSheel = [[UIActionSheet alloc] initWithTitle:msg
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:@"Wipe"
                                                               otherButtonTitles:nil];
        linkoutActionSheel.actionSheetStyle = UIActionSheetStyleDefault;
        
        [linkoutActionSheel showInView:self.view];
    }
}

@end
