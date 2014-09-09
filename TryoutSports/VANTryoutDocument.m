//
//  VANTryoutDocument.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-11.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANTryoutDocument.h"
#import "VANImportUtility.h"
#import "UIImage+resize.h"

NSString * const kCustomFileUTI = @"com.avbrink.TryoutSports.tryoutsports";

NSString * const kProfileContextKey = @"kContextKey";
NSString * const kProfileImageKey = @"kProfileImageKey";
NSString * const kProfileImageContentModeKey = @"kProfileImageContentModeKey";

@implementation VANTryoutDocument

#pragma mark - Error Handelling functions

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    
    NSLog(@"Error: %@ userInfo=%@", error.localizedDescription, error.userInfo);
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
}

-(NSString *)fileNameExtensionForType:(NSString *)typeName saveOperation:(UIDocumentSaveOperation)saveOperation {
    return @"tryoutsports";
}

-(NSString *)savingFileType {
    return kCustomFileUTI;
}

-(void)initiate {
    
}

-(NSFileWrapper *)wrapper {
    if (!_wrapper) {
        _wrapper = [[NSFileWrapper alloc] initWithURL:self.fileURL options:NSFileWrapperReadingImmediate error:nil];
    }
    return _wrapper;
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    //Because the URL is already set it can be the placeholder. The API will use this to determine that an object of class type NSURL will be sent.
    return self.fileURL;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return self.fileURL;
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return kCustomFileUTI;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    UIImage *scaledImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:@"/icons/icon60.png"] scaledToFitToSize:size];
    //Add image to improve the look of the alert received on the other side, make sure it is scaled to the suggested size.
    return scaledImage;
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    
    return YES;
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return @"Tryout Sports Event";
}

@end
