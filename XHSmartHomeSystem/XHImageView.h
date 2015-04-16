//
//  XHImageView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHImageView : UIView {
    CAShapeLayer *arcLayer;
    UIBezierPath *path;
}
/* the backgroundColor must clear */
@property (nonatomic) NSString *imageName;
@property (nonatomic) UIColor *color;  //progress color
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat lineWidth;

@end
