//
//  VANAthleteDetailController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectTableViewController.h"

@class AthleteSkills;

@interface VANAthleteDetailController : VANManagedObjectTableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;
-(void)back;

@property (strong, nonatomic) AthleteSkills *athleteSkills;
@property (strong, nonatomic) UITableViewCell *cell;
-(IBAction)keyboardResign:(id)sender;

- (IBAction)addPicture:(id)sender;

@end
