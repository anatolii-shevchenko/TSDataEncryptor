//
//  TSDataEncryptorController.m
//  DataEncryptor
//
//  Created by Tolik on 2/22/15.
//  Copyright (c) 2015 Tolik Shevchenko. All rights reserved.
//

#import "TSDataEncryptorController.h"
#import "TSDataEncryptor.h"

@interface TSDataEncryptorController ()

@property (nonatomic, weak) IBOutlet NSTextField *encryptTextField;
@property (nonatomic, weak) IBOutlet NSTextField *decryptTextField;
@property (nonatomic, weak) IBOutlet NSTextField *passTextField;
@property (nonatomic, weak) IBOutlet NSTextField *infoTextField;

@property (nonatomic, strong, readonly) NSOpenPanel *encryptPanel;
@property (nonatomic, strong, readonly) NSOpenPanel *decryptPanel;

- (IBAction)onEncrypt:(id)sender;
- (IBAction)onDecrypt:(id)sender;

- (IBAction)onEncryptOpen:(id)sender;
- (IBAction)onDecryptOpen:(id)sender;

@end

@implementation TSDataEncryptorController
@synthesize encryptPanel = _encryptPanel;
@synthesize decryptPanel = _decryptPanel;

#pragma mark - panels stuff

- (NSOpenPanel *)createPanel
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.prompt = @"Choose";
    panel.showsHiddenFiles = YES;
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = YES;
    
    return panel;
}

- (NSOpenPanel *)encryptPanel
{
    if (_encryptPanel == nil)
    {
        _encryptPanel = [self createPanel];
    }
    
    return _encryptPanel;
}

- (NSOpenPanel *)decryptPanel
{
    if (_decryptPanel == nil)
    {
        _decryptPanel = [self createPanel];
    }
    
    return _decryptPanel;
}

#pragma mark - IBAction's

- (IBAction)onEncrypt:(id)sender
{
    BOOL isDirectory = NO;
    NSString *filePath = self.encryptTextField.stringValue;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    NSString *operationResult = nil;
    if (isExist)
    {
        NSSet *filesSet = nil;
        if (isDirectory)
        {
            filesSet = [self allFilesForDirectory:filePath];
        }
        else
        {
            filesSet = [NSSet setWithObject:filePath];
        }
        operationResult = [self resultAfterFilesEncryption:filesSet];
    }
    else
    {
        operationResult = @"There is no input file/directory!";
    }
    self.infoTextField.stringValue = operationResult;
}

- (IBAction)onDecrypt:(id)sender
{
    BOOL isDirectory = NO;
    NSString *filePath = self.decryptTextField.stringValue;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    NSString *operationResult = nil;
    if (isExist)
    {
        NSSet *filesSet = nil;
        if (isDirectory)
        {
            filesSet = [self allFilesForDirectory:filePath];
        }
        else
        {
            filesSet = [NSSet setWithObject:filePath];
        }
        operationResult = [self resultAfterFilesDecryption:filesSet];
    }
    else
    {
        operationResult = @"There is no input file/directory!";
    }
    self.infoTextField.stringValue = operationResult;
}

- (IBAction)onEncryptOpen:(id)sender
{
    NSInteger clicked = [self.encryptPanel runModal];
    if (clicked == NSFileHandlingPanelOKButton)
    {
        self.encryptTextField.stringValue = self.encryptPanel.URL.path;
        
        if (0 == self.decryptTextField.stringValue.length)
        {
            NSURL *suggestedURL = [self suggestedDirectoryURLFromPanel:self.encryptPanel];
            self.decryptPanel.directoryURL = suggestedURL;
            self.decryptTextField.stringValue = suggestedURL.path;
        }
    }
}

- (IBAction)onDecryptOpen:(id)sender
{
    NSInteger clicked = [self.decryptPanel runModal];
    if (clicked == NSFileHandlingPanelOKButton)
    {
        self.decryptTextField.stringValue = self.decryptPanel.URL.path;
        
        if (0 == self.encryptTextField.stringValue.length)
        {
            NSURL *suggestedURL = [self suggestedDirectoryURLFromPanel:self.decryptPanel];
            self.encryptPanel.directoryURL = suggestedURL;
            self.encryptTextField.stringValue = suggestedURL.path;
        }
    }
}

#pragma mark - private methods

- (NSURL *)suggestedDirectoryURLFromPanel:(NSOpenPanel *)panel
{
    NSURL *suggestedDirectoryURL = nil;
    
    NSArray *pathes = panel.URLs;
    if (pathes.count == 1)
    {
        if ([[pathes firstObject] isEqualTo:panel.directoryURL]) //one directory has been chosen
        {
            suggestedDirectoryURL = panel.directoryURL.URLByDeletingLastPathComponent;
        }
        else //one file has been chosen
        {
            suggestedDirectoryURL = panel.directoryURL;
        }
    }
    else
    {
        suggestedDirectoryURL = panel.directoryURL;
    }
    
    return suggestedDirectoryURL;
}

- (NSString *)resultAfterFilesEncryption:(NSSet *)files
{
    if (0 == files.count)
    {
        return @"There is no file in choosen directory!";
    }
    
    NSString *outputPath = self.decryptTextField.stringValue;
    NSString *password = self.passTextField.stringValue;
    
    NSError *error = nil;
    for (NSString *file in files)
    {
        [TSDataEncryptor encryptFileWithPath:file
                                 outFilePath:[outputPath stringByAppendingPathComponent:file.lastPathComponent]
                                        pass:password
                                       error:&error];
        if (nil != error)
        {
            return [NSString stringWithFormat:@"Error: %@", error.description];
        }
    }
    return @"Done!";
}

- (NSString *)resultAfterFilesDecryption:(NSSet *)files
{
    if (0 == files.count)
    {
        return @"There is no file in choosen directory!";
    }
    
    NSString *outputPath = self.encryptTextField.stringValue;
    NSString *password = self.passTextField.stringValue;
    
    NSError *error = nil;
    for (NSString *file in files)
    {
        [TSDataEncryptor decryptFileWithPath:file
                                 outFilePath:[outputPath stringByAppendingPathComponent:file.lastPathComponent]
                                        pass:password
                                       error:&error];
        if (nil != error)
        {
            return [NSString stringWithFormat:@"Error: %@", error.description];
        }
    }
    return @"Done!";
}

- (NSSet *)allFilesForDirectory:(NSString *)directoryPath
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
            [allFiles unionSet:[self allFilesForDirectory:fileURL.path]];
        }
    }
    return allFiles;
}

@end
