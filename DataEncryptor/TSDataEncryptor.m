//
//  TSDataEncryptor.m
//  DataEncryptor
//
//  Created by Tolik on 3/10/15.
//  Copyright (c) 2015 Tolik Shevchenko. All rights reserved.
//

#import "TSDataEncryptor.h"

@implementation TSDataEncryptor

//openssl des3 -salt -in 1.png -out 2.txt -k pass1
+ (void)encryptFileWithPath:(NSString *)inFilePath outFilePath:(NSString *)outFilePath pass:(NSString *)pass
{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    task.arguments = @[@"-c", [NSString stringWithFormat:@"openssl des3 -salt -in %@ -out %@ -k %@", inFilePath, outFilePath, pass]];
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *grepOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", grepOutput);
}

//openssl des3 -d -salt -in 2.txt -out 3.png -k pass1
+ (void)decryptFileWithPath:(NSString *)inFilePath outFilePath:(NSString *)outFilePath pass:(NSString *)pass
{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    task.arguments = @[@"-c", [NSString stringWithFormat:@"openssl des3 -d -salt -in %@ -out %@ -k %@", inFilePath, outFilePath, pass]];
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *grepOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", grepOutput);
}

@end
