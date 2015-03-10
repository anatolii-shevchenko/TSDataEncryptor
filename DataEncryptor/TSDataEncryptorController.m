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

@property (nonatomic, weak) IBOutlet NSTextField *inTextField;
@property (nonatomic, weak) IBOutlet NSTextField *outTextField;

@property (nonatomic, strong, readonly) NSOpenPanel *openPanel;
@property (nonatomic, strong, readonly) NSSavePanel *savePanel;

- (IBAction)onEncrupt:(id)sender;
- (IBAction)onDecrupt:(id)sender;

- (IBAction)onInOpen:(id)sender;
- (IBAction)onOutOpen:(id)sender;

@end

@implementation TSDataEncryptorController
@synthesize openPanel = _openPanel;
@synthesize savePanel = _savePanel;

- (NSOpenPanel *)openPanel
{
    if (_openPanel == nil)
    {
        _openPanel = [NSOpenPanel openPanel];
        _openPanel.prompt = @"Income folder/file";
        _openPanel.showsHiddenFiles = YES;
        _openPanel.canChooseDirectories = YES;
        _openPanel.allowsMultipleSelection = YES;
    }
    
    return _openPanel;
}

- (NSSavePanel *)savePanel
{
    if (_savePanel == nil)
    {
        _savePanel = [NSSavePanel savePanel];
        _savePanel.prompt = @"Outcome folder/file";
        _savePanel.showsHiddenFiles = YES;
        _savePanel.canCreateDirectories = YES;
    }
    
    return _savePanel;
}

- (IBAction)onEncrupt:(id)sender
{
    NSError *error = nil;
    [TSDataEncryptor encryptFileWithPath:self.inTextField.stringValue
                             outFilePath:self.outTextField.stringValue
                                    pass:@"pass1"
                                   error:&error];
    if (nil == error)
    {
        
    }
    else
    {
        
    }
}

- (IBAction)onDecrupt:(id)sender
{
    [TSDataEncryptor decryptFileWithPath:self.inTextField.stringValue
                             outFilePath:self.outTextField.stringValue
                                    pass:@"pass1"
                                   error:nil];
}

- (IBAction)onInOpen:(id)sender
{
    NSInteger clicked = [self.openPanel runModal];
    if (clicked == NSFileHandlingPanelOKButton)
    {
        self.inTextField.stringValue = self.openPanel.URL.path;
        
        NSArray *pathes = self.openPanel.URLs;
        
        if (pathes.count == 1)
        {
            if ([[pathes firstObject] isEqualTo:self.openPanel.directoryURL])//only one directory has been chosen
            {
                self.savePanel.directoryURL = self.openPanel.directoryURL.URLByDeletingLastPathComponent;
//                self.savePanel.message = [NSString stringWithFormat:@"out_%@", self.openPanel.directoryURL.lastPathComponent];
            }
            else//one file has been chosen
            {
                self.savePanel.directoryURL = self.openPanel.directoryURL;
//                self.savePanel.message = [NSString stringWithFormat:@"out_%@", self.openPanel.nameFieldLabel];
            }
        }
        else
        {
            self.savePanel.directoryURL = self.openPanel.directoryURL;
//            self.savePanel.message = @"out";
        }
        self.outTextField.stringValue = self.savePanel.URL.path;
    }
}

- (IBAction)onOutOpen:(id)sender
{
    NSInteger clicked = [self.savePanel runModal];
    if (clicked == NSFileHandlingPanelOKButton)
    {
        self.outTextField.stringValue = self.savePanel.URL.path;
    }
}

@end
