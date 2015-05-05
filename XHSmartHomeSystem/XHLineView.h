//
//  XHLineView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/26/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHLineView : UIView

@property (assign, getter=isPull) BOOL pull;

- (void)pullDown:(NSTimeInterval)animationDuration;
- (void)pullUp;

@end
