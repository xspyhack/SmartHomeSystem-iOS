//
//  XHSocketThread.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol XHSocketThreadDelegate <NSObject>

@optional
- (void)didReadBuffer:(NSString *)buffer;

@end

@interface XHSocketThread : NSObject<GCDAsyncSocketDelegate>

+ (XHSocketThread *)shareInstance; // singleton

@property (nonatomic, strong, readwrite) id<XHSocketThreadDelegate> delegate;

- (void)connect;
- (void)disconnect;

// read socket
- (void)read;
- (void)readWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

// write socket
- (void)write:(NSString *)buffer;
- (void)write:(NSString *)buffer withTimeout:(NSTimeInterval)timeout tag:(long)tag;

@end
