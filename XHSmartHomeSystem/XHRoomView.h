//
//  XHRoomView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHRoomModel;

@interface XHRoomView : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *humidityLabel;

@property (nonatomic, strong) XHRoomModel *roomModel;
@property (nonatomic, copy) NSDate *updateTime;

@end
