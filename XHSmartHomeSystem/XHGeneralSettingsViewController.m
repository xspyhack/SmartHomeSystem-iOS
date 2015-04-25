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
#import "XHAboutViewController.h"
#import "XHDisplayViewController.h"
#import "XHFeaturesViewController.h"
#import "XHLanguageViewController.h"

@implementation XHGeneralSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGeneralGroup];
    [self setupLanguageGroup];
    [self setupLinkOutGroup];
}

#pragma mark - private methods

- (void)setupGeneralGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *generalItem = [XHTableViewCellArrowItem itemWithTitle:@"General"];
    generalItem.destViewContorller = [XHAboutViewController class];
    
    XHTableViewCellArrowItem *displayItem = [XHTableViewCellArrowItem itemWithTitle:@"Display"];
    displayItem.destViewContorller = [XHDisplayViewController class];
    
    XHTableViewCellArrowItem *featureItem = [XHTableViewCellArrowItem itemWithTitle:@"Features"];
    featureItem.destViewContorller = [XHFeaturesViewController class];
    
    group.items = @[generalItem, displayItem, featureItem];
}

- (void)setupLanguageGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *languageItem = [XHTableViewCellArrowItem itemWithTitle:@"Language"];
    languageItem.destViewContorller = [XHLanguageViewController class];
    
    group.items = @[languageItem];
}

- (void)setupLinkOutGroup
{
    CGRect rect = CGRectMake(0, 15, self.view.frame.size.width, 45);
    UIButton *linkout = [[UIButton alloc] initWithFrame:rect];
    linkout.backgroundColor = XHOrangeColor;
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

#pragma mark - actionSheel delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Link out" message:@"Link out success." delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
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
@end
