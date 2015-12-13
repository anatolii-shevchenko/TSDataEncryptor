//
//  TSDataEncryptorHelper.m
//  DataEncryptor
//
//  Created by Tolik Shevchenko on 12/13/15.
//  Copyright © 2015 Tolik Shevchenko. All rights reserved.
//

#import "TSDataEncryptorHelper.h"
#import "TSDataEncryptor.h"

@implementation TSDataEncryptorHelper

#pragma mark - public methods

+ (NSSet *)allFilesSubpathesForDirectoryPath:(NSString *)directoryPath
{
    NSMutableSet *allFilesSubpathes = [[NSMutableSet alloc] init];
    NSSet *allFilesPathes = [self allFilesForDirectoryPath:directoryPath];
    
    for (NSString *filePath in allFilesPathes)
    {
        NSString *fileSubpath = [filePath substringFromIndex:[directoryPath length]];
        [allFilesSubpathes addObject:fileSubpath];
    }
    return allFilesSubpathes;
}

+ (NSString *)resultAfterFilesEncryptionWithInputPath:(NSString *)inputPath
                                       filesSubpathes:(NSSet *)filesSubpathes
                                           outputPath:(NSString *)outputPath
                                             password:(NSString *)password
{
    if (0 == filesSubpathes.count)
    {
        return @"There is no file in choosen directory!";
    }
    
    NSError *error = nil;
    for (NSString *filesSubpath in filesSubpathes)
    {
        NSString *inputFilePath = [inputPath stringByAppendingPathComponent:filesSubpath];
        NSString *outputFilePath = [outputPath stringByAppendingPathComponent:filesSubpath];
        
        [TSDataEncryptor encryptFileWithPath:inputFilePath
                                 outFilePath:outputFilePath
                                        pass:password
                                       error:&error];
        if (nil != error)
        {
            return [NSString stringWithFormat:@"Error: %@", error.description];
        }
    }
    return @"Done!";
}

+ (NSString *)resultAfterFilesDecryptionWithInputPath:(NSString *)inputPath
                                       filesSubpathes:(NSSet *)filesSubpathes
                                           outputPath:(NSString *)outputPath
                                             password:(NSString *)password
{
    if (0 == filesSubpathes.count)
    {
        return @"There is no file in choosen directory!";
    }
    
    NSError *error = nil;
    for (NSString *filesSubpath in filesSubpathes)
    {
        NSString *inputFilePath = [inputPath stringByAppendingPathComponent:filesSubpath];
        NSString *outputFilePath = [outputPath stringByAppendingPathComponent:filesSubpath];
        
        [TSDataEncryptor decryptFileWithPath:inputFilePath
                                 outFilePath:outputFilePath
                                        pass:password
                                       error:&error];
        if (nil != error)
        {
            return [NSString stringWithFormat:@"Error: %@", error.description];
        }
    }
    return @"Done!";
}

#pragma mark - private methods

+ (NSSet *)allFilesForDirectoryPath:(NSString *)directoryPath
{
    NSMutableSet *allFiles = [[NSMutableSet alloc] init];
    
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtURL:[NSURL fileURLWithPath:directoryPath]
                                         includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                         errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
                                             if (error)
                                             {
                                                 NSLog(@"[Error] %@ (%@)", error, url);
                                                 return NO;
                                             }
                                             return YES;
                                         }];
    
    for (NSURL *fileURL in enumerator)
    {
        NSString *filename = nil;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory = nil;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if (![isDirectory boolValue])
        {
            [allFiles addObject:fileURL.path];
        }
        else
        {
            [allFiles unionSet:[self allFilesForDirectoryPath:fileURL.path]];
        }
    }
    return allFiles;
}

@end
