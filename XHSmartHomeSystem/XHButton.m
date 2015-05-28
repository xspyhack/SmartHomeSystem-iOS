//
//  XHButton.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHButton.h"
#import "XHColorTools.h"

@implementation XHButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.layer.cornerRadius = self.frame.size.width / 2;
    //self.layer.borderWidth = 1.0f;
    //self.layer.borderColor = [XHColorTools themeColor].CGColor;
    self.backgroundColor = [[XHColorTools themeColor] colorWithAlphaComponent:0.8];
    self.titleLabel.textColor = [UIColor whiteColor];
}

@end
