//
//  XHCryptTools.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHCryptTools : NSObject

+ (NSString *)md5WithKey:(NSString *)key;
+ (NSData *)AES256EncryptWithPlaintext:(NSString *)plaintext key:(NSString *)key;
+ (NSString *)AES256DecryptWithCiphertext:(NSData *)ciphertext key:(NSString *)key;

@end
