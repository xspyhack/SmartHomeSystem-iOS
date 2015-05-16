//
//  XHSocketThread.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHSocketThread.h"
#import "GCDAsyncSocket.h"
#import "XHTokenTools.h"
#import "XHTokenModel.h"

enum _DisconnectByWho {
    DisconnectByUser = 0,
    DisconnectByServer
} DisconnectByWho;

@interface XHSocketThread ()

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) NSInteger port;

@end

@implementation XHSocketThread

+ (XHSocketThread *)shareInstance
{
    static XHSocketThread *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

- (void)connect
{
    //_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![self.socket connectToHost:self.host onPort:12345 error:&err]) {
        XHLog(@"connect failed");
        [self showAlert:[NSString stringWithFormat:@"Connect to %@ failed. Error: %@", self.host, err.description]];
    } else {
        XHLog(@"connecting");
    }
}

- (void)disconnect
{
    //self.socket.userData = DisconnectByUser;
    [self showAlert:@"Disconnection"];
    if ([self.socket isConnected]) {
        [self.socket disconnect];
    }
}

- (void)read
{
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)readWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.socket readDataWithTimeout:timeout tag:tag];
}

- (void)write:(NSString *)buffer
{
    NSData *data = [buffer dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:0];
}

- (void)write:(NSString *)buffer withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    NSData *data = [buffer dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:timeout tag:tag];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"connected");
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // loop read data
    NSString *butter = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:XHUpdateRoomModelNotification object:nil userInfo:@{@"BUFFER" : butter}];
//    });
    
    if ([self.delegate respondsToSelector:@selector(didReadBuffer:)]) {
        [self.delegate didReadBuffer:butter];
    }
    // wait and read next buffer
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //
    XHLog(@"write success");
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self showAlert:[NSString stringWithFormat:@"Disconnect with error: %@", err.description]];
//    if ((int)sock.userData == DisconnectByServer) {
//        // reconnect
//        [self connect];
//    } else if (sock.userData == DisconnectByUser) {
//        return;
//    }
}

#pragma mark - getter

- (GCDAsyncSocket *)socket
{
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }

    return _socket;
}

- (NSString *)host
{
    if (!_host) {
        _host = [XHTokenTools tokenModel].gateway;
    }
    return _host;
}

- (NSInteger)port
{
    if (!_port) {
        _port = [[NSUserDefaults standardUserDefaults] integerForKey:@"XHPort"];
    }
    return _port;
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Socket"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
