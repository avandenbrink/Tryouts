//
//  VANAthleteListViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectTableViewController.h"
#import "VANNewAthleteController.h"


@interface VANAthleteListViewController : VANManagedObjectTableViewController

@property (strong, nonatomic) NSMutableArray *athleteList;
- (IBAction)addNewAthlete:(id)sender;

@end
