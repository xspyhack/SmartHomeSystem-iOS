//
//  XHRoomTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHRoomModel;

@interface XHRoomTools : NSObject

+ (XHRoomModel *)roomModelWithString:(NSString *)aString;

@end
