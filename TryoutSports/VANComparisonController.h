//
//  VANComparisonController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"

@interface VANComparisonController : VANManagedObjectViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeA;
@property (weak, nonatomic) IBOutlet UIButton *changeB;
@property (strong,nonatomic) Athlete *athleteA;
@property (strong,nonatomic) Athlete *athleteB;
- (IBAction)changeAthlete:(id)sender;

@end
