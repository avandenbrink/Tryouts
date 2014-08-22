//
//  VANTryoutDocument.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-11.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANTryoutDocument.h"

@implementation VANTryoutDocument



#pragma mark - Error Handelling functions

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    
    NSLog(@"Error: %@ userInfo=%@", error.localizedDescription, error.userInfo);
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    //Because the URL is already set it can be the placeholder. The API will use this to determine that an object of class type NSURL will be sent.
    return self.fileURL;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    //Return the URL being used. This URL has a custom scheme (see ReadMe.txt and Info.plist for more information about registering a custom URL scheme).
    return self.fileURL;
}

//- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
//{
//    //Add image to improve the look of the alert received on the other side, make sure it is scaled to the suggested size.
//    return [UIImage imageWithImage:[UIImage imageNamed:kCustomURLImageName] scaledToFitToSize:size];
//}

@end
