//
//  VANIntroViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#define kClubName   @"club"
#define kWebsite    @"web"


#import "VANManagedObjectViewController.h"
#import "VANAppSettingsViewController.h"
#import "VANFullNavigationViewController.h"
#import "VANMainMenuViewController.h"
#import "VANNewEventViewController.h"

@class VANFetchObjectConfiguration;



@interface VANIntroViewController : VANManagedObjectViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, VANAddAppSettingsDelegate>

@property (strong, nonatomic) VANFetchObjectConfiguration *config;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (weak, nonatomic) IBOutlet UIButton *appSettings;
@property (weak, nonatomic) IBOutlet UIImageView *cornerImageView;

- (IBAction)addEvent:(id)sender;


@end
