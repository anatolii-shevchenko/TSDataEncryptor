//
//  TSDataEncryptorHelper.h
//  DataEncryptor
//
//  Created by Tolik Shevchenko on 12/13/15.
//  Copyright © 2015 Tolik Shevchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSDataEncryptorHelper : NSObject

+ (NSSet *)allFilesSubpathesForDirectoryPath:(NSString *)directoryPath;

+ (void)encryptFilesWithInputPath:(NSString *)inputPath
                   filesSubpathes:(NSSet *)filesSubpathes
                       outputPath:(NSString *)outputPath
                         password:(NSString *)password
                      updateBlock:(void(^)(float progress, NSString *updateString))updateBlock;

+ (void)decryptFilesWithInputPath:(NSString *)inputPath
                   filesSubpathes:(NSSet *)filesSubpathes
                       outputPath:(NSString *)outputPath
                         password:(NSString *)password
                      updateBlock:(void(^)(float progress, NSString *updateString))updateBlock;

@end
