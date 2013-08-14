//
//  VANSimpleTextEditCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "Event.h"
#import "AthleteTest.h"
#import "AthleteSkills.h"


@interface VANMotherCell : UITableViewCell <UIAlertViewDelegate>

@property (strong, nonatomic) Athlete *athlete;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) AthleteTest *test;
@property (strong, nonatomic) AthleteSkills *skill;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (nonatomic) BOOL expandable;

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;
-(void)configureWith:(NSManagedObject *)object;
-(IBAction)keyboardResign:(id)sender;

@end
