//
//  XHCircularView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 6/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHCircularView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *title;

@end
