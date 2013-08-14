//
//  VANNewAthleteControllerPad.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewAthleteController.h"
#import "VANAthleteListControllerPad.h"

@interface VANNewAthleteControllerPad : VANNewAthleteController <UIPopoverControllerDelegate>

@property (weak, nonatomic) VANAthleteListControllerPad *controller;
@end
