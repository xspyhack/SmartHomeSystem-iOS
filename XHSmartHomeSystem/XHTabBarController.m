//
//  XHTabBarController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTabBarController.h"
#import "XHNavigationController.h"
#import "XHHomeViewController.h"
#import "XHMessagesViewController.h"
#import "XHSettingsViewController.h"
#import "XHColorTools.h"
#import "XHSocketThread.h"

@interface XHTabBarController ()<XHSocketThreadDelegate>

@end

@implementation XHTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [XHColorTools themeColor];
    [XHSocketThread shareInstance].delegate = self;
    [[XHSocketThread shareInstance] connect];
    
    [self setupSubViewController];
}

- (void)dealloc
{
    XHLocate();
}

- (void)setupSubViewController
{
    // add sub viewController
    XHHomeViewController *hVC = [[XHHomeViewController alloc] init];
    [self addSubViewController:hVC title:NSLocalizedString(@"Home", nil) imageName:@"tabbar_home" selectedImageName:@"tabbar_home_highlighted"];
    
    XHMessagesViewController *mVC = [[XHMessagesViewController alloc] init];
    [self addSubViewController:mVC title:NSLocalizedString(@"Messages", nil) imageName:@"tabbar_messages" selectedImageName:@"tabbar_messages_highlighted"];
    
    XHSettingsViewController *sVC = [[XHSettingsViewController alloc] init];
    [self addSubViewController:sVC title:NSLocalizedString(@"Settings", nil) imageName:@"tabbar_settings" selectedImageName:@"tabbar_settings_highlighted"];
}

- (void)addSubViewController:(UIViewController *)subVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // set selected text attribute text color
    // we can set tintColor insta
    NSMutableDictionary *selectedtextAttrs = [NSMutableDictionary dictionary];
    selectedtextAttrs[NSForegroundColorAttributeName] = [XHColorTools themeColor];
    [subVC.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    subVC.view.backgroundColor = [UIColor whiteColor];
    
    // set title
    //subVC.tabBarItem.title = title;
    //subVC.navigationItem.title = title;
    subVC.title = title; // it just need set titile property
    subVC.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IOS_7_OR_LATER) {
        // here we should use UIImage's new property renderingMode,
        // and set with UIImageRenderingModeAlwaysAutomatic
        // if we need to rendering the tabBarItem image automatic according tintColor.
        // and if we need to use the original image, we should set renderingMode with
        // UIImageRenderingModeAlwaysOriginal.
        //selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
        //selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    subVC.tabBarItem.selectedImage = selectedImage;
    
    XHNavigationController *navVC = [[XHNavigationController alloc] initWithRootViewController:subVC];
    
    [self addChildViewController:navVC];
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
