//
//  XHHomeDataModel.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHomeDataModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *humidity;

@end
