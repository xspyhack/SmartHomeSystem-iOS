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
    
    XHTableViewCellArrowItem *gatewayItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Gateway", nil)];
    gatewayItem.destinationContorller = [XHGatewayViewController class];
    
    XHTableViewCellArrowItem *displayItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Display", nil)];
    displayItem.destinationContorller = [XHDisplayViewController class];
    
    XHTableViewCellArrowItem *featureItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Features", nil)];
    featureItem.destinationContorller = [XHFeaturesViewController class];
    
    group.items = @[ gatewayItem, displayItem, featureItem ];
}

- (void)setupLanguageGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    self.languageItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Language", nil)];
    self.languageItem.destinationContorller = [XHLanguageViewController class];
    
    group.items = @[ self.languageItem ];
}

- (void)setupWipeCacheGroup
{
    CGRect rect = CGRectMake(0, 15, self.view.frame.size.width, 40);
    UIButton *wipeCacheButton = [[UIButton alloc] initWithFrame:rect];
    wipeCacheButton.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:.8f];
    [wipeCacheButton setTitle:NSLocalizedString(@"Wipe Cache Partition", nil) forState:UIControlStateNormal];
    [wipeCacheButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wipeCacheButton addTarget:self action:@selector(wipeCacheButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = wipeCacheButton;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wipe cache", nil)
                                                        message:NSLocalizedString(@"Wipe cache partition success.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
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
    NSString *msg = NSLocalizedString(@"It will wipe all your cache.", nil);
    
    if (IOS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *wipeCache = [UIAlertAction actionWithTitle:NSLocalizedString(@"Wipe", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // link out
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:wipeCache];
        [alertController addAction:cancel];
        [alertController.view setTintColor:[UIColor grayColor]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *linkoutActionSheel = [[UIActionSheet alloc] initWithTitle:msg
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                          destructiveButtonTitle:NSLocalizedString(@"Wipe", nil)
                                                               otherButtonTitles:nil];
        linkoutActionSheel.actionSheetStyle = UIActionSheetStyleDefault;
        
        [linkoutActionSheel showInView:self.view];
    }
}

@end
