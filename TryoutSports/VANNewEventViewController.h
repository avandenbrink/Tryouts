//
//  VANNewEventViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#import "VANTryoutDocument.h"


@protocol VANNewEventSettingsDelegate

- (void)removeDocument:(VANTryoutDocument *)document;
- (BOOL)changNameOfDocument:(VANTryoutDocument *)document to:(NSString *)name;

@end

#import <UIKit/UIKit.h>
#import "VANMainMenuViewController.h"
#import "VANTextFieldCell.h"
#import "VANBoolCell.h"
#import "VANAppDelegate.h"
#import "VANTeamColor.h"
#import "VANNewSkillsAndTestsController.h"
#import "NewTableConfiguration.h"

@interface VANNewEventViewController : VANManagedObjectTableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, VANTableViewCellExpansionDelegate>

@property (nonatomic) BOOL isNewEvent;
@property (weak, nonatomic) id <VANNewEventSettingsDelegate> delegate;
@property (strong, nonatomic) VANTryoutDocument *document;
- (IBAction)saveEvent:(id)sender;

@end

