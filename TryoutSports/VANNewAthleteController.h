//
//  VANNewAthleteController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "VANManagedObjectTableViewController.h"
#import "VANAthleteListTabController.h"

@interface VANNewAthleteController : VANManagedObjectTableViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) VANAthleteListTabController *delegate;
- (IBAction)saveNewAthlete:(id)sender;
-(void)cancel;
- (IBAction)launchCamera:(id)sender;



@end
