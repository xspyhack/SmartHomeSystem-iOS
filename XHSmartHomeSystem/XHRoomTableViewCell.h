//
//  XHRoomTableViewCell.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHRoomView;
@class XHRoomModel;

@interface XHRoomTableViewCell : UITableViewCell

@property (nonatomic, strong) XHRoomModel *roomModel;
@property (nonatomic, strong) XHRoomView *roomView;
@property (nonatomic, assign) CGFloat height;

@end
