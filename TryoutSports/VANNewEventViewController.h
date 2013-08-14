//
//  VANNewEventViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANIntroViewController.h"
#import "VANMainMenuViewController.h"
#import "VANTextFieldCell.h"
#import "VANBoolCell.h"
#import "VANAppDelegate.h"
#import "VANTeamColor.h"
#import "VANNewSkillsAndTestsController.h"

@interface VANNewEventViewController : VANManagedObjectTableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

- (IBAction)saveEvent:(id)sender;
- (void)cancel;

@end
