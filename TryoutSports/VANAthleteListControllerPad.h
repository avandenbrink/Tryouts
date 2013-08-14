//
//  VANAthleteListControllerPad.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteListViewController.h"
#import "VANAthleteDetailControllerPad.h"

@interface VANAthleteListControllerPad : VANAthleteListViewController

@property (strong, nonatomic) UIPopoverController *popController;
@property (strong, nonatomic) VANAthleteDetailControllerPad *detailController;

@end
