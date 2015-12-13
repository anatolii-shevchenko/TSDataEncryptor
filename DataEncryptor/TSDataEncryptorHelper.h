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

+ (NSString *)resultAfterFilesEncryptionWithInputPath:(NSString *)inputPath
                                       filesSubpathes:(NSSet *)filesSubpathes
                                           outputPath:(NSString *)outputPath
                                             password:(NSString *)password;

+ (NSString *)resultAfterFilesDecryptionWithInputPath:(NSString *)inputPath
                                       filesSubpathes:(NSSet *)filesSubpathes
                                           outputPath:(NSString *)outputPath
                                             password:(NSString *)password;
@end
