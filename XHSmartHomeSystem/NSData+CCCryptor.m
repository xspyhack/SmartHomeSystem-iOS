//
//  NSData+CCCryptor.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "NSData+CCCryptor.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (CCCryptor)

- (NSData *)AES256EncryptWithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES256,
                                            NULL,
                                            [self bytes], dataLength, // input
                                            buffer, bufferSize, // output
                                            &numBytesEncrypted);
    if (cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES256,
                                            NULL,
                                            [self bytes], dataLength, // input
                                            buffer, bufferSize, // output
                                            &numBytesDecrypted);
    if (cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
