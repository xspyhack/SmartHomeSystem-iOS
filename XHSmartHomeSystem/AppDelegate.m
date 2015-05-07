//
//  AppDelegate.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/10/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "AppDelegate.h"
#import "XHTabBarController.h"
#import "XHNewFeatureViewController.h"
#import "XHLinkinViewController.h"
#import "XHSetupTools.h"
#import "XHTokenModel.h"
#import "XHTokenTools.h"
#import "XHColorTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [XHColorTools themeColor]; // set theme color
    
    // set rootViewController
    /*
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"token.plist"];
    NSLog(@"%@", filePath);
    //
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"token" ofType:@"plist"];
    NSLog(@"%@", filePath);
    NSDictionary *token = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@", token);
     */
    
    // is new user
    [XHSetupTools check];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    // use archiver
    XHTokenModel *token = [XHTokenTools tokenModel];
    
    // if exists token
    if (token) {
        XHLog(@"%@", token.password);
        // first, if it is first time using this version, it will show the new version's feature.
        NSString *versionKey = @"CFBundleVersion";
        versionKey = (__bridge NSString *)kCFBundleVersionKey;
        
        // get last time save version key
        NSString *lastVersion = [defaults objectForKey:versionKey];
        
        // get current version key
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
        if ([currentVersion isEqualToString:lastVersion]) {
            self.window.rootViewController = [[XHTabBarController alloc] init];
        } else {
            self.window.rootViewController = [[XHNewFeatureViewController alloc] init];
            // save this version key
            [defaults setObject:currentVersion forKey:versionKey];
            // write now
            [defaults synchronize];
        }
    } else {
        self.window.rootViewController = [[XHLinkinViewController alloc] init];
    }
    
    // show window
    [self.window makeKeyAndVisible];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        //
        [defaults setObject:@"Enabled" forKey:@"NotificationEnabled"];
        [self addLocalNotification];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [defaults setObject:@"Disabled" forKey:@"NotificationEnabled"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotificationReceived:)
                                                 name:XHThemeDidChangeNotification
                                               object:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onNotificationReceived:(NSNotification *)notification
{
    if ([notification.name isEqualToString:XHThemeDidChangeNotification]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XHTabBarController *tabBarVC = [[XHTabBarController alloc] init]; // alloc a new tabBarViewController
            
            // important, here must tell system there hasn't color observer
            // if not, it will crash when update theme and set display color next.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:NO forKey:@"XHHaveColorObserver"];
            
            tabBarVC.selectedIndex = 2; // go to settings view
            self.window.tintColor = [XHColorTools themeColor]; // update tintColor
            self.window.rootViewController = nil;
            self.window.rootViewController = tabBarVC;

        });
//        XHTabBarController *tabBarVC = [[XHTabBarController alloc] init]; // alloc a new tabBarViewController
//        
//        // important, here must tell system there hasn't color observer
//        // if not, it will crash when update theme and set display color next.
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setBool:NO forKey:@"XHHaveColorObserver"];
//        
//        tabBarVC.selectedIndex = 2; // go to settings view
//        self.window.tintColor = [XHColorTools themeColor]; // update tintColor
//        self.window.rootViewController = nil;
//        self.window.rootViewController = tabBarVC;
    }
}

- (void)addLocalNotification
{
    // define local notification object
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:100];
    notification.repeatInterval = 2;
    notification.alertBody = @"your sex services has been called, hava a good time.";
    notification.applicationIconBadgeNumber = 1;
    notification.alertAction = @"open";
    notification.alertLaunchImage = @"1";
    notification.soundName = @"msg.caf";
    notification.userInfo = @{@"id":@1,@"user":@"b233"};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)removeLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
