//
//  XHMessageSettingViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessageSettingViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellArrowItem.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHColorTools.h"
#import "XHMessageTools.h"

@implementation XHMessageSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do any additional setup here.
    [self setupGroup];
    [self setupClearGroup];
}

- (void)setupGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *backgroundItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Background", nil)];
    XHTableViewCellArrowItem *searchItem = [XHTableViewCellArrowItem itemWithTitle:NSLocalizedString(@"Search History", nil)];
    searchItem.clicked = ^{
        //[self.navigationController popViewControllerAnimated:YES];
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self.parentViewController];
        [searchController.searchBar sizeToFit];
    };

    group.items = @[ backgroundItem, searchItem ];
}

- (void)setupClearGroup
{
    CGRect rect = CGRectMake(0, 45, self.view.frame.size.width, 40);
    UIButton *clear = [[UIButton alloc] initWithFrame:rect];
    clear.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:.8f];
    [clear setTitle:NSLocalizedString(@"Clear Message History", nil) forState:UIControlStateNormal];
    [clear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = clear;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.groups count] - 1) {
        return 30;
    }
    return 15;
}

- (void)clearButtonClicked
{
    XHLog(@"Clear");
    NSString *msg = NSLocalizedString(@"Clear all messages history", nil);
    
    if (IOS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *clearMessages = [UIAlertAction actionWithTitle:NSLocalizedString(@"Clear", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // clear
            [XHMessageTools removeMessages];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHClearMessagesNotification object:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:clearMessages];
        [alertController addAction:cancel];
        [alertController.view setTintColor:[UIColor grayColor]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *clearActionSheel = [[UIActionSheet alloc] initWithTitle:msg
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                          destructiveButtonTitle:NSLocalizedString(@"Clear", nil)
                                                               otherButtonTitles:nil];
        clearActionSheel.actionSheetStyle = UIActionSheetStyleDefault;
        
        [clearActionSheel showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // clear
        [XHMessageTools removeMessages];
        [[NSNotificationCenter defaultCenter] postNotificationName:XHClearMessagesNotification object:nil];
    }
}

@end
