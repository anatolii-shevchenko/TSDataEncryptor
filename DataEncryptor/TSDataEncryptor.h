//
//  TSDataEncryptor.h
//  DataEncryptor
//
//  Created by Tolik on 3/10/15.
//  Copyright (c) 2015 Tolik Shevchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSDataEncryptor : NSObject

+ (void)encryptFileWithPath:(NSString *)inFilePath
                outFilePath:(NSString *)outFilePath
                       pass:(NSString *)pass
                      error:(NSError **)error;

+ (void)decryptFileWithPath:(NSString *)inFilePath
                outFilePath:(NSString *)outFilePath
                       pass:(NSString *)pass
                      error:(NSError **)error;

@end
