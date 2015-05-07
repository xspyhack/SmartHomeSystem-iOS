//
//  XHCryptTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHCryptTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XHCryptTools

+ (NSString *)md5WithKey:(NSString *)key
{
    const char *cStrValue = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, strlen(cStrValue), result);
    NSMutableString *ciphertext = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ciphertext appendFormat:@"%02x", result[i]];
    }
    return ciphertext;
}

+ (NSData *)AES256EncryptWithPlaintext:(NSString *)plaintext key:(NSString *)key
{
    NSData *temp = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    return [temp AES256EncryptWithKey:key];
}

+ (NSString *)AES256DecryptWithCiphertext:(NSData *)ciphertext key:(NSString *)key
{
    NSData *temp = [ciphertext AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
}

@end
