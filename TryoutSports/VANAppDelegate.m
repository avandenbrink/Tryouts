//
//  VANAppDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-07-31.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAppDelegate.h"
#import "VANIntroViewController.h"
#import "VANImportUtility.h"
#import "VANTryoutDocument.h"
#import "VANViewImportDocumentViewController.h"
#import "VANGlobalMethods.h"


NSString * const kCustomScheme = @"tryoutsports";
NSString * const kMainIPadStoryboardName = @"Main_iPad";
NSString * const kMainIPhoneStoryboardName = @"Main_iPhone";
NSString * const kProfileViewControllerIdentifier = @"ProfileViewController";

//Custom Notifications used when receiving content
NSString * const DisplayingSaveWindowNotification = @"DisplayingSaveWindow";
NSString * const SavedReceivedProfilesNotification = @"SavedReceivedProfiles";
NSString * const SavedCustomURLNotification = @"SavedCustomURL";

NSString * const kDocumentsInboxFolder = @"Inbox";
NSString *const kEventType = @"Event";
NSString *const kEventAthleteRelationship = @"athletes";

@interface VANAppDelegate ()

@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) VANIntroViewController *rooViewController;

@property (strong, nonatomic) NSMutableArray *receivedProfileQueue;
@property (strong, nonatomic) UINavigationController *receivedProfilesNavigationController;

@property (strong, nonatomic) NSMutableArray *savedFileNames;

@property (strong, nonatomic) UIWindow *saveReceivedWindow;
@property (strong, nonatomic) UIPopoverController *popoverController;

@end

@implementation VANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.rootNavigationController = (UINavigationController *)self.window.rootViewController;
    self.rooViewController = self.rootNavigationController.viewControllers[0];

    self.savedFileNames = [NSMutableArray array];
    
    NSString *UUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
    if (!UUID) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        UUID = (__bridge_transfer NSString *) CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:@"UUID"];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self handleDocumentInbox];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Application Listenner for Importing Events from other Devices 

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url) {
        url = [url URLByResolvingSymlinksInPath];
        NSLog(@"%@",url);
        for (NSInteger i = 0; i < [self.receivedProfileQueue count]; i++) {
            if ([[self.receivedProfileQueue objectAtIndex:i] isKindOfClass:[VANTryoutDocument class]]) {
                VANTryoutDocument *doc = [self.receivedProfileQueue objectAtIndex:i];
                
                NSLog(@"%@",doc.fileURL);
                NSURL *docURL = [doc.fileURL URLByResolvingSymlinksInPath];
                if ([[docURL absoluteString] isEqualToString:[url absoluteString]]) {
                    return true;
                }
            } else if ([[self.receivedProfileQueue objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                NSArray *fileArray = [self.receivedProfileQueue objectAtIndex:i];
                NSURL *fileURL = [[fileArray firstObject] URLByResolvingSymlinksInPath];
                if ([[fileURL absoluteString] isEqualToString:[url absoluteString]]) {
                    return true;
                }
                
            }
        }
        
        NSString *fileType = [[url path] pathExtension];
        if (url.scheme && [url.scheme isEqualToString:kCustomScheme]) {
            
            [VANImportUtility saveCustomURL:url];
            [[NSNotificationCenter defaultCenter] postNotificationName:SavedCustomURLNotification object:nil];
            
            if ([self.rootNavigationController visibleViewController] == self.rooViewController && !self.saveReceivedWindow) {
                //Tell Root View Controller to process this Object
            }
        } else if ([fileType isEqualToString:@"tryoutsports"]) {
            VANTryoutDocument *document = [[VANTryoutDocument alloc] initWithFileURL:url];
            
            if (document) {
                [self enqueueDocument:document];
            }
        } else if ([fileType isEqualToString:@"csv"]) {
            NSString *fileContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            NSCharacterSet *newLineCharacter = [NSCharacterSet newlineCharacterSet];
            NSArray *urls = [NSArray arrayWithObject:url];
            NSArray *fileRows = [urls arrayByAddingObjectsFromArray:[fileContents componentsSeparatedByCharactersInSet:newLineCharacter]];
            
            if (fileRows) {
                [self enqueueDocument:fileRows];
            }
        }
        
    }
    return true;
}

-(void)handleDocumentInbox {
    NSString *inboxPath = [[VANImportUtility documentsDirectory] stringByAppendingPathComponent:kDocumentsInboxFolder];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *inboxDocuments = [fileManager contentsOfDirectoryAtPath:inboxPath error:nil];
    
    
    for (NSString *path in inboxDocuments) {
        NSURL *url = [NSURL fileURLWithPath:[inboxPath stringByAppendingPathComponent:path]];
        url = [url URLByResolvingSymlinksInPath];
        [self application:[UIApplication sharedApplication] openURL:url sourceApplication:@"" annotation:nil];
    }
}

- (void)removeInboxItem:(NSURL *)itemURL
{
    //Clean up the inbox once the file has been processed
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[itemURL path] error:&error];
    
    if (error) {
        NSLog(@"ERROR: Inbox file could not be deleted");
    }
}

#pragma mark - Airdropped Present Received Document Methods

- (void)enqueueDocument:(id)document
{
    if (!_receivedProfileQueue) {
        _receivedProfileQueue = [NSMutableArray array];
    }
    
    @synchronized(self.receivedProfileQueue)
    {
        [self.receivedProfileQueue addObject:document];
        
        //If first recevied, profile present
        if (self.receivedProfileQueue.count == 1) {
            [self presentFirstProfile];
        }
    }
}

- (void)dequeueDocument
{
    @synchronized(self.receivedProfileQueue) {
        if (self.receivedProfileQueue.count > 0) {
            [self.receivedProfileQueue removeObjectAtIndex:0];
        }
    }
}

- (void)presentFirstProfile
{
    //Create Window
    self.saveReceivedWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.saveReceivedWindow setWindowLevel:UIWindowLevelNormal];
    
    //Notify observers that the save window will appear
    [[NSNotificationCenter defaultCenter] postNotificationName:DisplayingSaveWindowNotification object:nil];
    
    [self populateViewImportController];
    
    //Set frame below the screen
    CGRect originalFrame = self.saveReceivedWindow.frame;
    CGRect newFrame = self.saveReceivedWindow.frame;
    newFrame.origin.y = newFrame.origin.y + newFrame.size.height;
    self.saveReceivedWindow.frame = newFrame;
    
    //Create animation to have window slide up from bottom of the screen
    [self.saveReceivedWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.saveReceivedWindow.frame = originalFrame;
                     }
                     completion:nil];
}

-(void)populateViewImportController {
    
    //Determin the Document Type
    if ([[self.receivedProfileQueue firstObject] isKindOfClass:[VANTryoutDocument class]]) {
        
        VANTryoutDocument *document = [self.receivedProfileQueue firstObject];
        
        //Create profileViewController to display received profile
        VANViewImportDocumentViewController *profileViewController = [self createProfileViewControllerForProfile:document];
        
        if (!self.receivedProfilesNavigationController) {
            //Create a navigation controller to handle displaying multiple incoming profiles
            self.receivedProfilesNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            [self.saveReceivedWindow setRootViewController:self.receivedProfilesNavigationController];
        } else {
            // Update Navigation Controller
            [self.receivedProfilesNavigationController pushViewController:profileViewController animated:YES];
        }
        
        profileViewController.titleLabel.text = @"Import Event";

        document.persistentStoreOptions = @{NSReadOnlyPersistentStoreOption : [NSNumber numberWithBool:TRUE]};
        //Set values on view:
        [document openWithCompletionHandler:^(BOOL succeess) {
            if (succeess) {
                NSManagedObjectContext *context = document.managedObjectContext;
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
                
                NSArray *eventResults = [context executeFetchRequest:request error:nil];
                Event *event;
                if ([eventResults count] == 0) {
                    NSLog(@"Warning! There is no data in this file");
                    [self discardDocument:document];
                    event = nil;
                } else {
                    if ([eventResults count] > 1) {
                        NSLog(@"WARNING! There are two events in this document");
                    }
                    event = [eventResults firstObject];
                }
                
                if (event) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    
                    profileViewController.valueArray = (NSMutableArray *)@[event.name
                                                                           ,@"Coach Name"
                                                                           ,[formatter stringFromDate:event.startDate]
                                                                           ,[NSString stringWithFormat:@"%lu",(unsigned long)[event.athletes count]]];
                    
                    profileViewController.labelArray = (NSMutableArray *)@[@"Event Name:",
                                                                           @"From:",
                                                                           @"Event Date",
                                                                           @"Number of Athletes"];
                    [profileViewController.tableView reloadData];
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not open file" message:@"Warning: This file could not be openned.  It may be out of date, or corrupted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self discardDocument:document];
            }
        }];
        
        
    } else if ([[self.receivedProfileQueue firstObject] isKindOfClass:[NSArray class]]) {
        
        NSArray *fileRows = [self.receivedProfileQueue firstObject];
        NSArray *titles = [[fileRows objectAtIndex:1] componentsSeparatedByString:@","];
        NSMutableArray *fileColumnTitles = [NSMutableArray arrayWithCapacity:[titles count]];
        for (NSString *string in titles) {
            NSString *titleString = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
            [fileColumnTitles addObject:[titleString lowercaseString]];
        }
        
        NSInteger nameColumn = [self getColumnforDataType:[VANImportUtility singleNameVariations] Data:fileColumnTitles];
        NSInteger lastNameColumn = [self getColumnforDataType:[VANImportUtility lastNameVariations] Data:fileColumnTitles];
        NSInteger numberColumn = [self getColumnforDataType:[VANImportUtility numberVariations] Data:fileColumnTitles];
        
        NSMutableArray *allNames = [NSMutableArray array];
        NSMutableArray *allNumbers = [NSMutableArray array];
        
        if (nameColumn == NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot find name column" message:@"Warning: could not find a column titled 'name', cannot convert file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self discardDocument:nil];
        }
        
        for (NSInteger i = 2; i < [fileRows count]; i++) { // Start at 2 because we want to skip url and titles
            NSString *rowString = [fileRows objectAtIndex:i];
            NSArray *rowData = [rowString componentsSeparatedByString:@","];
            
            if (nameColumn != NSNotFound) {
                NSString *rowName = [rowData objectAtIndex:nameColumn];
                if (lastNameColumn != NSNotFound) {
                    rowName = [rowName stringByAppendingString:[NSString stringWithFormat:@" %@", [rowData objectAtIndex:lastNameColumn]]];
                }
                if ([rowName isEqualToString:@""]) {
                    continue;
                }
                [allNames addObject:rowName];
            }
            
            if (numberColumn != NSNotFound) {
                NSString *rowNumber = [rowData objectAtIndex:numberColumn];
                [allNumbers addObject:rowNumber];
            }
        }
        
        VANViewImportDocumentViewController *profileViewController = [self createProfileViewControllerForProfile:nil];
        
        if (!self.receivedProfilesNavigationController) {
            //Create a navigation controller to handle displaying multiple incoming profiles
            self.receivedProfilesNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            [self.saveReceivedWindow setRootViewController:self.receivedProfilesNavigationController];
        } else {
            // Update Navigation Controller
            [self.receivedProfilesNavigationController pushViewController:profileViewController animated:YES];
        }
        
        profileViewController.titleLabel.text = @"Import Athletes";
        profileViewController.valueArray = allNumbers;
        profileViewController.labelArray = allNames;
        [profileViewController.tableView reloadData];
    }
}


- (VANViewImportDocumentViewController *)createProfileViewControllerForProfile:(VANTryoutDocument *)document
{
    UIStoryboard *sb;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        sb = [UIStoryboard storyboardWithName:kMainIPadStoryboardName bundle:nil];
    } else {
        sb = [UIStoryboard storyboardWithName:kMainIPhoneStoryboardName bundle:nil];
    }
    
    VANViewImportDocumentViewController *profileViewController = [sb instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
    profileViewController.document = document;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Discard"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(discardDocument:)];
    UIBarButtonItem *addButton =  [[UIBarButtonItem alloc] initWithTitle:@"Add to an Event"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(addToDocument:)];
    
    if (document) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                    target:self
                                                                                    action:@selector(saveDocument:)];
        profileViewController.navigationItem.rightBarButtonItems = @[addButton, saveButton];
    } else {
        profileViewController.navigationItem.rightBarButtonItem = addButton;
    }

    profileViewController.navigationItem.leftBarButtonItem = cancelButton;

    return profileViewController;
}


-(void)addToDocument:(id)sender {
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
    
    UIBarButtonItem *addToButton = [self.receivedProfilesNavigationController.topViewController.navigationItem.rightBarButtonItems firstObject];
    [self.popoverController presentPopoverFromBarButtonItem:addToButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    tableViewController.tableView.dataSource = self;
    tableViewController.tableView.delegate = self;
}


- (void)saveDocument:(id)sender
{
    VANTryoutDocument *document = [self.receivedProfileQueue firstObject];
    if (document) {
        //Save profile to persistent file
        [VANImportUtility saveDocument:document];
    }
    
    UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
    if ([controller.topViewController isKindOfClass:[VANIntroViewController class]]) {
        VANIntroViewController *introController = (VANIntroViewController *)controller.topViewController;
        [introController getLocalFiles];
    }
    [self dequeueDocument];
    [self presentNextProfile];
}

- (void)discardDocument:(id)sender
{
    if ([[self.receivedProfileQueue firstObject] isKindOfClass:[VANTryoutDocument class]]) {
        VANTryoutDocument *doc = [self.receivedProfileQueue firstObject];
        [self removeInboxItem:doc.fileURL];
    } else if ([[self.receivedProfileQueue firstObject] isKindOfClass:[NSArray class]]){
        NSURL *fileURL = [[self.receivedProfileQueue firstObject] firstObject];
        [self removeInboxItem:fileURL];
    }
    [self dequeueDocument];
    [self presentNextProfile];
}


- (void)presentNextProfile
{
    if (self.receivedProfileQueue.count > 0) {
        [self populateViewImportController];
        
    } else if (self.receivedProfilesNavigationController) { // If there are no more documents Queue is empty
        //Animate the window away (slide down)
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.saveReceivedWindow resignKeyWindow];
                             
                             CGRect newFrame = self.saveReceivedWindow.frame;
                             newFrame.origin.y = newFrame.origin.y + newFrame.size.height;;
                             self.saveReceivedWindow.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                             
                             self.saveReceivedWindow = nil;
                             self.receivedProfilesNavigationController = nil;
                             
//                             //Only show profile table if at least one profile was saved
//                             if ([self.savedFileNames count] > 0) {
//                                 
//                                 NSDictionary *userInfo = @{kSavedReceivedProfilesFileNamesKey : [self.savedFileNames copy]};
//                                 
//                                 //Notify observers at least one profile was saved
//                                 [[NSNotificationCenter defaultCenter] postNotificationName:SavedReceivedProfilesNotification object:nil userInfo:userInfo];
//                                 
//                                 //Show profile table if currently in the sharing types table, otherwise don't, the user could be in the middle of something
//                                 if ([self.navigationController visibleViewController] == self.sharingTypesViewController) {
//                                     [self.sharingTypesViewController showProfilesTable];
//                                 }
//                                 
//                                 [self.savedFileNames removeAllObjects];
//                             }
                         }];
    }
}

#pragma mark - UITABLEVIEW Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[VANImportUtility getLocalFileList] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [[VANImportUtility getLocalFileList] objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VANTryoutDocument *document = [VANImportUtility getLocalDocumentforName:[[VANImportUtility getLocalFileList] objectAtIndex:indexPath.row]];
    
    if ([[self.receivedProfileQueue firstObject] isKindOfClass:[NSArray class]]) {
        [self addAthleteListToDocument:document];
    } else if ([[self.receivedProfileQueue firstObject] isKindOfClass:[VANTryoutDocument class]]) {
        [self addDocumentDataToDocument:document];
    }
}

-(void)addAthleteListToDocument:(VANTryoutDocument *)document {
    
    [document openWithCompletionHandler:^(BOOL success) {
        if (success) {
            //Get List and separate into rows
            
            NSManagedObjectContext *context = document.managedObjectContext;
            context.mergePolicy = NSRollbackMergePolicy;
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEventType];
            
            NSArray *eventResults = [context executeFetchRequest:request error:nil];
            Event *event;
            if ([eventResults count] == 0) {
                NSLog(@"Warning, there were no events found in the existing document");
            } else {
                if ([eventResults count] > 1) {
                    NSLog(@"WARNING! There are two events in this document");
                }
                event = [eventResults firstObject];
            }
            
            
            NSArray *fileRows = [self.receivedProfileQueue firstObject];
            
            //Collect First row as titles and optimize labels
            NSArray *titles = [[fileRows objectAtIndex:1] componentsSeparatedByString:@","];
            NSMutableArray *fileColumnTitles = [NSMutableArray arrayWithCapacity:[titles count]];
            for (NSString *string in titles) {
                NSString *titleString = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
                [fileColumnTitles addObject:[titleString lowercaseString]];
            }
            
            //Use Titles to find the columns of each of the key values
            NSInteger nameColumn = [self getColumnforDataType:[VANImportUtility singleNameVariations] Data:fileColumnTitles];
            NSInteger nameColumnSecondary = [self getColumnforDataType:[VANImportUtility lastNameVariations] Data:fileColumnTitles];
            NSInteger numberColumn = [self getColumnforDataType:[VANImportUtility numberVariations] Data:fileColumnTitles];
            NSInteger emailColumn = [self getColumnforDataType:[VANImportUtility emailVariations] Data:fileColumnTitles];
            NSInteger phoneColumn = [self getColumnforDataType:[VANImportUtility phoneVariations] Data:fileColumnTitles];
            NSInteger positionColumn = [self getColumnforDataType:[VANImportUtility positionVariations] Data:fileColumnTitles];
            NSInteger birthdateColumn = [self getColumnforDataType:[VANImportUtility birthdateVariations] Data:fileColumnTitles];
            
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            NSString *str =@"3/15/2012 9:15 PM";
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            for (NSInteger i = 1; i < [fileRows count]; i++) { // Start at 1 because we want to skip titles
                NSString *rowString = [fileRows objectAtIndex:i];
                NSArray *rowData = [rowString componentsSeparatedByString:@","];
                
                //If they have a name we will include them in the addition
                if (![[rowData objectAtIndex:nameColumn] isEqualToString:@""]) {
                    
                    Athlete *athlete = (Athlete*)[VANGlobalMethods addNewRelationship:kEventAthleteRelationship toManagedObject:event andSave:NO];
                    NSString *aName = [rowData objectAtIndex:nameColumn];
                    if (nameColumnSecondary != NSNotFound) {
                        aName = [aName stringByAppendingString:[NSString stringWithFormat:@" %@",[rowData objectAtIndex:nameColumnSecondary]]];
                    }
                    
                    athlete.name = aName;
                    if (numberColumn != NSNotFound) {
                        NSString *numberString = [rowData objectAtIndex:numberColumn];
                        [f setNumberStyle:NSNumberFormatterDecimalStyle];
                        NSNumber *number = [f numberFromString:numberString];
                        if (number) {
                            athlete.number = number;
                        }
                    }
                    
                    if (emailColumn != NSNotFound) {
                        athlete.email = [rowData objectAtIndex:emailColumn];
                    }
                    if (phoneColumn != NSNotFound) {
                        athlete.phoneNumber = [rowData objectAtIndex:phoneColumn];
                    }
                    if (birthdateColumn != NSNotFound) {
                        [formatter setDateFormat:@"MM/dd/yyyy"];
                        NSDate *date = [formatter dateFromString:str];
                        athlete.birthday = date;
                    }
                    if (positionColumn != NSNotFound) {
                        NSString *position = [rowData objectAtIndex:positionColumn];
                        athlete.position = position;
                    }
                }
            }
            [self.popoverController dismissPopoverAnimated:YES];
            [VANGlobalMethods saveManagedObject:event];
            [self removeInboxItem:[[self.receivedProfileQueue firstObject] firstObject]];
            [self dequeueDocument];
            [self presentNextProfile];
        }
    }];
}



-(void)addDocumentDataToDocument:(VANTryoutDocument *)document {
    
}

-(void)removeAthleteatIndex:(NSInteger)index
{
    if ([[self.receivedProfileQueue firstObject] isKindOfClass:[NSArray class]]) {
        NSMutableArray *rows = (NSMutableArray *)[self.receivedProfileQueue firstObject];
        [rows removeObjectAtIndex:index+1];
        [self.receivedProfileQueue replaceObjectAtIndex:0 withObject:rows];
    }
}

-(NSInteger)getColumnforDataType:(NSArray *)data Data:(NSArray *)array {
    for (NSString *name in data) {
        NSInteger column = [array indexOfObject:name];
        if (column != NSNotFound) {
            return column;
        }
    }
    return NSNotFound;
}

@end
