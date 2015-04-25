//
//  XHColorsView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/24/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHColorsView : UIView

@property (nonatomic, copy) NSString *master;
@property (nonatomic, assign) BOOL pull;

- (void)pullDown:(NSTimeInterval)animationDuration;
- (void)pullUp;

@end
