//
//  VANAthleteListViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectViewController.h"
#import "VANNewAthleteController.h"


@interface VANAthleteListViewController : VANManagedObjectViewController

@property (strong, nonatomic) NSMutableArray *athleteList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addNewAthlete:(id)sender;

@end
