//
//  VANAthleteDetailControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteDetailControllerPad.h"

@interface VANAthleteDetailControllerPad ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation VANAthleteDetailControllerPad

-(void)back {
    [self.delegate releaseAthleteDetailViews];
    NSLog(@"Releasing Athlete Detail View");
}

@end
