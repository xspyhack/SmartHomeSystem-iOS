//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMessageContentButton : UIButton

//bubble imgae
@property (nonatomic, retain) UIImageView *backImageView;

@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) BOOL isMyMessage;


@end
