//
//  VANIntroViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "VANIntroViewController.h"
#import "VANAppDelegate.h"
#import "Event.h"
#import "VANTeamColor.h"
#import "VANFetchObjectConfiguration.h"

static NSString* const fileNameType = @".tryoutsports";
static NSString* const managedObjectEvent = @"Event";

@interface VANIntroViewController ()

@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(void)getLocalFiles;

@end

@implementation VANIntroViewController

@synthesize fetchedResultsController = _fetchedResultsController;

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

-(NSURL *)localURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [[NSFileManager defaultManager]
               URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask
               appropriateForURL:nil
               create:NO
               error:nil];
    });
    return url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    
    //Adjust Views
    self.eventsTable.backgroundView = nil;
    self.eventsTable.backgroundColor = [UIColor clearColor];
    
    //Collect Files locally and in the cloud
    self.fileList = [NSMutableArray array];
    [self getLocalFiles];
    
    //Old method here
//    NSError *error = nil;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error loading data", @"Error loading data") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting", @"Error was: %@, quitting"), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
//        [alert show];
//    }
    
    [[UIApplication sharedApplication] keyWindow].tintColor = [teamColor findTeamColor];
    
    //Temporary//
    self.cloudEnabled = NO;
    //End Temporary//
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.eventsTable reloadData];
}

-(BOOL)isCloudEnabled {
    return self.containerURL != nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileList count];
    
//        id<NSFetchedResultsSectionInfo>sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
//        //if ([sectionInfo numberOfObjects] != 0) {
//            return [sectionInfo numberOfObjects];
//        //} else {
//       //     return 1;
//       // }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.fileList objectAtIndex:indexPath.row];
    
    //[self configureCell:cell atIndexPath:indexPath];

    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    backgroundView.backgroundColor = [teamColor findTeamColor];
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
    
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    NSManagedObject *anEvent = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [anEvent valueForKey:@"name"];
    NSDate *date = [anEvent valueForKey:@"startDate"];
    cell.detailTextLabel.text = [__dateFormatter stringFromDate:date];
}

#pragma mark - Table view delegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fileName = [self.fileList objectAtIndex:indexPath.row];
        [self deleteEventDocumentWithName:nil orName:fileName];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VANTryoutDocument *document = [self createDocument:[self.fileList objectAtIndex:indexPath.row]];
    
    [document openWithCompletionHandler:^(BOOL success) {
        if (!success) {
            [NSException raise:NSGenericException format:@"Could Not Open File %@", [self.fileList objectAtIndex:indexPath.row]];
        } else {
            
            NSManagedObjectContext *context = document.managedObjectContext;
            context.mergePolicy = NSRollbackMergePolicy;
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:managedObjectEvent];
            
            NSArray *eventResults = [context executeFetchRequest:request error:nil];
            Event *event;
            if ([eventResults count] == 0) {
                NSLog(@"Warning, there were no events found in the existing document");
                event = [self createNewEventForContext:context];
            } else {
                if ([eventResults count] > 1) {
                    NSLog(@"WARNING! There are two events in this document");
                }
                
                event = [eventResults firstObject];
            }
            [self performSegueWithIdentifier:@"pushToMain" sender:@[event, document]];
        }
    }];
}

#pragma mark - FetchResultsController Setter

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //set Batch Size
    [fetchRequest setFetchBatchSize:20];
    
    //edit the sort key
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}



#pragma mark - FetchResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.eventsTable beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.eventsTable endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.eventsTable;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.eventsTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.eventsTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
}

#pragma mark - Other Custom Methods and PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToMain"]) {
        if ([sender isKindOfClass:[NSArray class]]) {
            VANMainMenuViewController *viewController = segue.destinationViewController;
            viewController.event = [sender firstObject];
            viewController.document = [sender lastObject];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Event Detail Error", @"Event Detail Error") message:NSLocalizedString(@"Error Showing Detail",@"Error Showing Detail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"We Don't Currently have a Segue by the Name: %@ Sent to IntroViewController", segue.identifier);
    }
}

- (void)appSettingsViewControllerDidFinish:(VANAppSettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.appSettings setTintColor:[teamColor findTeamColor]];
    VANFullNavigationViewController *controllers = (VANFullNavigationViewController *)[self navigationController];
    controllers.colorView.backgroundColor = [teamColor findTeamColor];
    [controllers.navigationBar setTintColor:[teamColor findTeamColor]];
    [self.view setNeedsDisplay];
}

- (IBAction)addEvent:(id)sender
{
    NSLog(@"This addEvent Button should be implemented somewhere else");
//    NSManagedObjectContext *managedObjectContext = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:managedObjectContext];
//
//    [self performSegueWithIdentifier:@"toEventSettings" sender:newEvent];
}


#pragma mark - Get File Methods

-(void)getLocalFiles
{
    // This surveys the local documents directory
    // After filtering the right file types
    // UrlsForFileNames is created with the full urls and file names
    // FileList is created to hold purely the names of all the files for display purposes
    // TableView is also refreshed
    
    NSArray* allContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.localURL includingPropertiesForKeys:nil options:0 error:nil];
    
    NSMutableArray *contents = [NSMutableArray array];
    for (NSURL *URLname in allContents) {
        NSString *name = [URLname absoluteString];
        if ([name rangeOfString:fileNameType].location != NSNotFound) {
            NSURL *url = [URLname URLByResolvingSymlinksInPath];
            NSLog(@"%@",url);
            [contents addObject:url];
        }
    }
    self.fileList = [NSMutableArray array];

    self.urlsForFileNames =
    [NSMutableDictionary dictionaryWithCapacity:
     [contents count]];
    
    for (NSURL* url in contents) {
        
        NSString* fileName = [url lastPathComponent];
        NSString* presentedName = [fileName stringByReplacingCharactersInRange:[fileName rangeOfString:fileNameType] withString:@""];
        [self.fileList addObject:presentedName];
        [self.urlsForFileNames setValue:url
                                 forKey:fileName];
        
    }
    [self.eventsTable reloadData];
    
}

-(void)getCloudFiles {
    
    //For a Future Look from example code from MultiDoc http://www.freelancemadscience.com/fmslabs_blog/2011/12/19/syncing-multiple-core-data-documents-using-icloud.html
    
    
    //    NSLog(@"Listing cloud files");
    //
    //    self.listOfFiles = [NSArray array];
    //
    //
    //    // Arbitrarially chose to start with a capacity of 100.
    //    self.urlsForFileNames =
    //    [NSMutableDictionary dictionaryWithCapacity:100];
    //
    //    NSMetadataQuery* query =
    //    [[NSMetadataQuery alloc] init];
    //
    //    [query setSearchScopes:
    //     [NSArray arrayWithObject:NSMetadataQueryUbiquitousDataScope]];
    //
    //    // We cannot look for the folder--must look for the
    //    // contained DocumentMetadata.plist.
    //    [query setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",
    //                         NSMetadataItemFSNameKey,
    //                         @"DocumentMetadata.plist"]];
    //
    //    NSNotificationCenter* center =
    //    [NSNotificationCenter defaultCenter];
    //
    //    id observer =
    //    [center
    //     addObserverForName:NSMetadataQueryDidFinishGatheringNotification
    //     object:query
    //     queue:nil
    //     usingBlock:^(NSNotification* notification) {
    //
    //
    //         NSLog(@"NSMetadataQuery finished gathering, found %d files",
    //               [query resultCount]);
    //
    //         // what's in the iCloud container
    //         NSDirectoryEnumerator* enumerator =
    //         [[NSFileManager defaultManager]
    //          enumeratorAtURL:self.containerURL
    //          includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
    //          options:0
    //          errorHandler:nil];
    //
    //         id object;
    //
    //         NSLog(@"iCloud Container Contents:");
    //         while (object = [enumerator nextObject]) {
    //             NSLog(@"%@\n\n", object);
    //         }
    //         NSLog(@"Done");
    //
    //
    //         // if we don't have any results, look at what is actually inside the iCloud container.
    //         if ([query resultCount] == 0) {
    //
    //             // Now clear the container -- must be done inside a file coordinator
    //             [[[NSFileCoordinator alloc] initWithFilePresenter:nil]
    //              coordinateWritingItemAtURL:self.containerURL
    //              options:NSFileCoordinatorWritingForDeleting
    //              error:nil
    //              byAccessor:^(NSURL *newURL) {
    //
    //                  [[NSFileManager defaultManager]
    //                   removeItemAtURL:newURL
    //                   error:nil];
    //              }];
    //         }
    //
    //         [query enableUpdates];
    //     }];
    //
    //    [self.notifications addObject:observer];
    //
    //    observer =
    //    [center
    //     addObserverForName:NSMetadataQueryDidUpdateNotification
    //     object:query
    //     queue:nil
    //     usingBlock:^(NSNotification *note) {
    //
    //         NSLog(@"Update recieved. %d files found so far",
    //               [query resultCount]);
    //
    //         [self processUpdate:query];
    //
    //     }];
    //
    //    [self.notifications addObject:observer];
    //
    //
    //    observer =
    //    [center
    //     addObserverForName:NSMetadataQueryGatheringProgressNotification
    //     object:query
    //     queue:nil
    //     usingBlock:^(NSNotification *note) {
    //
    //         NSLog(@"Progress notification recieved. %d files found so far",
    //               [query resultCount]);
    //
    //         [self processUpdate:query];
    //
    //     }];
    //
    //    [self.notifications addObject:observer];
    //
    //    [query startQuery];
    
}

-(void)createNewFileWithName:(NSString *)name {
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",name, fileNameType];
    
    NSURL *documentURL = [self.localURL URLByAppendingPathComponent:fileName];
    VANTryoutDocument *newDocument = [self createDocument:name];
    
    [newDocument saveToURL:documentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            [[NSFileManager defaultManager] removeItemAtURL:documentURL error:nil];
            return;
        }
        
        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.fileList count] inSection:0]];
        
        [self.fileList addObject:name];
        
        [self.eventsTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [newDocument openWithCompletionHandler:^(BOOL success) {
            if (!success) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not open Event" message:@"This event could not be opened. Please try restarting this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                
                NSManagedObjectContext *context = newDocument.managedObjectContext;
                context.mergePolicy = NSRollbackMergePolicy;
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:managedObjectEvent];
                
                NSArray *eventResults = [context executeFetchRequest:request error:nil];
                Event *event;
                if ([eventResults count] == 0) {
                    event = [self createNewEventForContext:context];
                    
                } else {
                    if ([eventResults count] > 1) {
                        NSLog(@"WARNING! There are two events in this document");
                    }
                    
                    event = [eventResults firstObject];
                }
                event.name = name;
                [self completeNewEventCreationWithEvent:event inDocument:newDocument];
            }
        }];
        
        
        
        
        //        if (self.cloudEnabled) {
        //
        //            NSURL* cloudURL =
        //            [self.containerURL URLByAppendingPathComponent:fileName];
        //
        //            dispatch_queue_t queue =
        //            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //
        //            dispatch_async(queue, ^{
        //
        //                NSError* error;
        //
        //                if (![[NSFileManager defaultManager]
        //                      setUbiquitous:YES
        //                      itemAtURL:documentURL
        //                      destinationURL:cloudURL
        //                      error:&error]) {
        //
        //                    [NSException
        //                     raise:NSGenericException
        //                     format:@"Error moving to iCloud container: %@",
        //                     error.localizedDescription];
        //                }
        //
        //                [self.urlsForFileNames setValue:cloudURL
        //                                         forKey:fileName];
        //
        //            });
        //        }
        
        
    }];

}

-(Event *)createNewEventForContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:managedObjectEvent inManagedObjectContext:context];
    Event *newEvent = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    return newEvent;
}

- (VANTryoutDocument *)createDocument:(NSString*)fileName {
    
    //     This instantiates a UIManagedDocument object
    //     But does not save or open it (does not create
    //     or read the underlying persistent store).
    
    NSDictionary *options;
    
    if (self.cloudEnabled) {
        
        
        options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, fileName, NSPersistentStoreUbiquitousContentNameKey, self.containerURL, NSPersistentStoreUbiquitousContentURLKey, nil];
    } else {
        options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    }
    NSString *fileNameFull = [fileName stringByAppendingString:fileNameType];
    
    NSURL* url = [self.urlsForFileNames valueForKey:fileNameFull];
    
    // if we don't have a valid URL, create a local url
    if (url == nil) {
        url = [self.localURL URLByAppendingPathComponent:fileNameFull];
        url = [url URLByStandardizingPath];
        [self.urlsForFileNames setValue:url forKey:fileNameFull];
    }
    
    // Now Create our document
    VANTryoutDocument* document = [[VANTryoutDocument alloc] initWithFileURL:url];
    
    
    document.persistentStoreOptions = options;
    
    return document;
}

-(void)completeNewEventCreationWithEvent:(Event *)event inDocument:(VANTryoutDocument *)document {
}


-(BOOL)changNameOfDocument:(VANTryoutDocument *)document to:(NSString *)name {
    
    NSString *fileName = [name stringByAppendingString:fileNameType];
    NSURL *newURL = [self.localURL URLByAppendingPathComponent:fileName];
    
    NSString *oldUrl = [document.fileURL absoluteString];
    NSString *oldFileName = [oldUrl stringByReplacingOccurrencesOfString:[self.localURL absoluteString] withString:@""];
    NSString *oldName = [fileName substringToIndex:([oldFileName length]-[fileNameType length])];
    
    BOOL success = [[NSFileManager defaultManager] moveItemAtURL:document.fileURL toURL:newURL error:nil];
    if (success) {
        [self.fileList removeObject:oldName];
        [self.fileList addObject:name];
        
        [self.urlsForFileNames removeObjectForKey:oldName];
        [self.urlsForFileNames setValue:newURL forKey:name];
    }
    return success;
}

-(void)deleteEventDocumentWithName:(VANTryoutDocument *)document orName:(NSString *)name
{
    //If we have a document instance, it may very well be open so we need to close it first
    if (document) {
        [document closeWithCompletionHandler:^(BOOL success){
            
            if([[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]){
                [[NSFileManager defaultManager] removeItemAtURL:document.fileURL error:nil];
            }

        
            NSString *fileUrl = [document.fileURL absoluteString];
            
            NSString *fileName = [fileUrl stringByReplacingOccurrencesOfString:[self.localURL absoluteString] withString:@""];
            NSString *namer = [fileName substringToIndex:([fileName length]-[fileNameType length])];
            
            NSUInteger row = [self.fileList indexOfObject:namer];
            if (row == NSNotFound) {
                NSLog(@"Not Found");
            }
            [self.fileList removeObjectAtIndex:row];
            [self.urlsForFileNames removeObjectForKey:fileName];
            [self.eventsTable reloadData];
        }];

    } else if (name) { //If name is provided then we will probably just remove it
        NSString *fileName = name;

        if (![fileName hasSuffix:fileNameType]) {
            fileName = [NSString stringWithFormat:@"%@%@",name,fileNameType];
        } else {
            name = [name substringToIndex:([name length]-[fileNameType length])];
        }
        NSURL *deleteURL = [self.urlsForFileNames objectForKey:fileName];
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:deleteURL error:&error];
        
        
        NSUInteger row = [self.fileList indexOfObject:name];
        if (row == NSNotFound) {
            NSLog(@"Not Found");
        }
        [self.fileList removeObjectAtIndex:row];
        [self.urlsForFileNames removeObjectForKey:fileName];
        [self.eventsTable reloadData];
    }
}

#pragma mark - NewEventViewController Delegate Methods
-(void)removeDocument:(VANTryoutDocument *)document {
    [self deleteEventDocumentWithName:document orName:nil];
}


@end
