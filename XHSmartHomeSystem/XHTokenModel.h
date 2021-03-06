//
//  XHTokenModel.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHTokenModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *gateway;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSDate *expires_time;

+ (instancetype)tokenModelWithDictionary:(NSDictionary *)dictionary;

@end
