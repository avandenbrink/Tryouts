//
//  VANBoolCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANBoolCell.h"
#import "VANIntroViewController.h"
#import "VANTeamColor.h"

#define  kLabelTextColor [UIColor colorWithRed:0.321569f green:0.4f blue:0.568627f alpha:1.0f]

@interface VANBoolCell ()

-(IBAction)switchflip:(id)sender;

@end

@implementation VANBoolCell

-(IBAction)switchflip:(id)sender {
    BOOL value = self.theSwitch.on;
    
    if ([_delegate respondsToSelector:@selector(setBoolValue:forPurpose:)]) {
        [_delegate setBoolValue:value forPurpose:self.purpose];
    }
}


@end
