//
//  XHNavigationController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNavigationController.h"
#import "XHColorTools.h"

@implementation XHNavigationController

// this method will be call when first time call this class
+ (void)initialize
{
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

#pragma mark - setup theme

// setup UINavigationBar theme
+ (void)setupNavigationBarTheme
{
    // it can setup all project's navigationbar by setting appearance
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    /*
    if (!IOS_7) {
        [appearance setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    }
    */
    
    // set text attribute
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [XHColorTools themeColor];
    //textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero]; // shadow
    //[appearance setTintColor:[XHColorTools themeColor]]; // set tint color
    //[appearance setBarTintColor:XHOrangeColor]; // set bar background color
    
    [appearance setTitleTextAttributes:textAttrs];
}

// setup  UIBarButtonItem theme
+ (void)setupBarButtonItemTheme
{
    // it can setup all project's navigationbar by setting appearance
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // set text attributes
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [XHColorTools themeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //[appearance setTintColor:[XHColorTools themeColor]];
    
    // set high lighted text attributes
    NSMutableDictionary *highLightedTextAttrs = [NSMutableDictionary dictionary];
    highLightedTextAttrs[NSForegroundColorAttributeName] = [XHColorTools defaultColor];
    [appearance setTitleTextAttributes:highLightedTextAttrs forState:UIControlStateHighlighted];
    
    // set disable text attributes
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // set background image
    //[appearance setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_btn_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarTheme
{
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [XHColorTools themeColor];
    //textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero]; // shadow
    //[self.navigationBar setTintColor:[XHColorTools themeColor]]; // set tint color
    
    [self.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)setBarButtonItemTheme
{
    // it can setup all project's navigationbar by setting appearance
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // set text attributes
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [XHColorTools themeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTheme];
    [self setBarButtonItemTheme];
}

#pragma mark - rewrite mothod

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // if push is not top stack viewcontroller, then hides tabbar
    // in the other words, when push other viewcontroller, hides tabbar
    // for example, navigation left item or right item.
    // or other view controller
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    
        // intercept push operate, and set navigation leftbarbutton
        //viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highLightedImageName:@"nav_back_highLighted" target:self action:@selector(back)];
        //viewController.navigationController.interactivePopGestureRecognizer.delegate = viewController;
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
#warning here use self, because self is current navigation controller which is using.
    [self popViewControllerAnimated:YES];
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