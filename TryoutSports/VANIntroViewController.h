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
#import "VANTryoutDocument.h"

static NSString* const defaultName = @"NewTryout";

@class VANFetchObjectConfiguration;

@interface VANIntroViewController : VANManagedObjectViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, VANAddAppSettingsDelegate, VANNewEventSettingsDelegate>

@property (strong, nonatomic) VANFetchObjectConfiguration *config;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (weak, nonatomic) IBOutlet UIButton *appSettings;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (readonly, nonatomic) NSURL *containerURL;
@property (readonly, nonatomic) NSURL *localURL;
@property (nonatomic/*, getter = isCloudEnabled*/) BOOL cloudEnabled;

@property (strong, nonatomic) NSMutableArray *fileList;
@property (strong, nonatomic) NSMutableDictionary *urlsForFileNames;

- (IBAction)addEvent:(id)sender;
-(void)getLocalFiles;

// Create New Event Methods available for calling and Subclassing
-(void)createNewFileWithName:(NSString *)name;
//When calling createNewFileWithName, this should be called in subclass to receive the event back
-(void)completeNewEventCreationWithEvent:(Event *)event inDocument:(VANTryoutDocument *)document;

//createDocument is called internally when creating a new Event
//Alternatively, it is also can be called from subclasses when openning an existing document
- (VANTryoutDocument *)createDocument:(NSString*)fileName;

//This method can be called as a backup incase existing event documents did not have any instance of Event in their datastores.
-(Event *)createNewEventForContext:(NSManagedObjectContext *)context;

-(void)deleteEventDocumentWithName:(VANTryoutDocument *)document orName:(NSString *)name;

-(BOOL)changeNameOfDocumentFileFrom:(NSString *)namePrev to:(NSString *)nameTo;

@end
