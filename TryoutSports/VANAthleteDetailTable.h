//
//  VANAthleteDetailTable.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 10/28/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTableView.h"
@class VANAthleteListControllerPad;
@class AthleteSkills;
@class Image;

@interface VANAthleteDetailTable : VANTableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) VANAthleteListControllerPad *frameDelegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) AthleteSkills *athleteSkills;
@property (strong, nonatomic) UITableViewCell *cell;

-(IBAction)keyboardResign:(id)sender;
-(IBAction)editAthleteProfile:(id)sender;
- (IBAction)addPicture:(id)sender;
-(void)back;
-(void)removeImagefromCell:(Image *)image;
-(void)readjustTeamCellWithAnimation:(BOOL)animate;
-(void)updateAthleteTagsCell;
@end
