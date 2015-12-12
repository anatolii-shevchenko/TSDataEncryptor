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
    panel.allowsMultipleSelection = YES;
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
    NSError *error = nil;
    [TSDataEncryptor encryptFileWithPath:self.encryptTextField.stringValue
                             outFilePath:self.decryptTextField.stringValue
                                    pass:self.passTextField.stringValue
                                   error:&error];
    if (nil == error)
    {
        
    }
    else
    {
        
    }
}

- (IBAction)onDecrypt:(id)sender
{
    [TSDataEncryptor decryptFileWithPath:self.decryptTextField.stringValue
                             outFilePath:self.encryptTextField.stringValue
                                    pass:self.passTextField.stringValue
                                   error:nil];
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

@end
