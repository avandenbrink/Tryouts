//
//  VANAppSettingsViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTeamColorChangerViewController.h"

@class VANIntroViewController;
@class VANAppSettingsViewController;

@protocol VANAddAppSettingsDelegate;

@interface VANAppSettingsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <VANAddAppSettingsDelegate> delegate;
@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) NSArray *setters;
@property (weak, nonatomic) IBOutlet UITextField *clubName;
@property (weak, nonatomic) IBOutlet UILabel *teamColor;
@property (weak, nonatomic) IBOutlet UITextField *webURL;

- (void)refreshFields;
- (IBAction)done:(id)sender;
- (IBAction)clubNameEdited:(id)sender;
- (IBAction)clubWebsiteEdited:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;


@end

@protocol VANAddAppSettingsDelegate
- (void)appSettingsViewControllerDidFinish:(VANAppSettingsViewController *)controller;
@end