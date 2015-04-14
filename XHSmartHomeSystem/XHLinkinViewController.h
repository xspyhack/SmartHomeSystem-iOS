//
//  XHLinkinViewController.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHLinkinViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *gatewayTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end
