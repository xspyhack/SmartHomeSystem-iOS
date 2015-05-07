//
//  NSData+CCCryptor.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CCCryptor)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
