//
//  XHTokenModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTokenModel.h"

@implementation XHTokenModel

+ (instancetype)tokenModelWithDict:(NSDictionary *)dict
{
    XHTokenModel *model = [[self alloc] init];
    model.gateway = dict[@"gateway"];
    model.password = dict[@"password"];
    
    // expires time = now + 1 week
    //NSInteger expires = 1000;
    
    NSDate *now = [NSDate date];
    model.expires_time = [now dateByAddingTimeInterval:XHTokenExpiresTime];
    
    return model;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.gateway = [aDecoder decodeObjectForKey:@"gateway"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.expires_time = [aDecoder decodeObjectForKey:@"expires_time"];
    }
    return self;
}

// it will call when write object to file
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.gateway forKey:@"gateway"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.expires_time forKey:@"expires_time"];
}

@end
