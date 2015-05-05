//
//  XHInputView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/5/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHInputView.h"
#import "XHColorTools.h"

#define XHControlSpace 20

@implementation XHInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.backgroundColor = XHCellBackgroundColor;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = .3f;
        self.layer.masksToBounds = NO;
        
        [self addSubview:self.label];
        [self addSubview:self.value];
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        CGRect rect = CGRectMake(XHControlSpace, 0, self.frame.size.width/2, self.frame.size.height);
        _label = [[UILabel alloc] initWithFrame:rect];
        //_label.textColor = [XHColorTools themeColor];
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}

- (UITextField *)value
{
    if (!_value) {
        CGRect rect = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2-XHControlSpace, self.frame.size.height);
        _value = [[UITextField alloc] initWithFrame:rect];
        _value.textColor = [XHColorTools themeColor];
        _value.textAlignment = NSTextAlignmentRight;
        _value.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // vertical alignment
        _value.placeholder = @"add value";
        _value.clearsOnBeginEditing = YES;
        _value.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _value.returnKeyType = UIReturnKeyDone;
        _value.delegate = self; // set delegate
    }
    return _value;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.value resignFirstResponder];
    return YES;
}

@end
