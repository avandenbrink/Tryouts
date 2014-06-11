//
//  VANAthleteDetailController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectTableViewController.h"

#import "VANAthleteProfileCell.h"

#import "VANDetailTableDelegate.h"
#import "VANPictureTaker.h"
#import "VANSoloImageViewer.h"


@class AthleteSkills;

@interface VANAthleteDetailController : VANManagedObjectTableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, VANPictureTakerDelegate, VANAthleteProfileDelegate, VANSoloImageViewerDelegate, VANDetailTableDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) AthleteSkills *athleteSkills;
@property (strong, nonatomic) UITableViewCell *cell;

-(IBAction)keyboardResign:(id)sender;
-(IBAction)editAthleteProfile:(id)sender;
-(void)addPicture;
-(void)back;
-(void)removeImagefromCell:(Image *)image;

@end