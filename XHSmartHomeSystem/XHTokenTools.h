//
//  XHTokenTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHTokenModel;

@interface XHTokenTools : NSObject

// setter
+ (void)save:(XHTokenModel *)tokenModel;
+ (void)remove:(XHTokenModel *)tokenModel;

// getter
+ (XHTokenModel *)tokenModel;

@end
