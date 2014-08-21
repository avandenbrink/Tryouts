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

//-(void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
//{
//    
//}
//
//-(void)finishedHandlingError:(NSError *)error recovered:(BOOL)recovered
//{
//    
//}

@end
