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

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.fileURL;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return self.fileURL;
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType
{
    return kCustomFileUTI;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    UIImage *scaledImage = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:@"icon60.png"] scaledToFitToSize:size];
    //Add image to improve the look of the alert received on the other side, make sure it is scaled to the suggested size.
    return scaledImage;
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return @"Tryout Sports Event";
}

@end
