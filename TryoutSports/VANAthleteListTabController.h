//
//  VANAthleteListTabController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTabController.h"

@interface VANAthleteListTabController : VANTabController <UITabBarControllerDelegate>

@property (weak, nonatomic) UIBarButtonItem *addButton;

-(IBAction)addNewAthlete:(id)sender;

@end
