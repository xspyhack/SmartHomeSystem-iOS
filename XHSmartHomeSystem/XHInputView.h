//
//  XHInputView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/5/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHInputView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *value;

@end
