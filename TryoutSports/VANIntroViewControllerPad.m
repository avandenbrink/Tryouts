//
//  VANIntroViewControllerPAD.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewControllerPad.h"
#import "VANSettingTabsControllerPad.h"
#import "VANTryoutDocument.h"

static NSInteger logoWidth = 300;
static NSInteger tableWidth = 400;
static NSInteger tableHeight = 400;
static NSInteger marginSpacing = 100;

static NSInteger popoverWidth = 300;
static NSInteger popoverMargins = 3;
static NSInteger popoverElementHeight = 50;

static NSString* const fileNameType = @".tryoutsports";
static NSString* const managedObjectEvent = @"Event";

@interface VANIntroViewControllerPad ()

@property (nonatomic) BOOL newLoad;
@property (readonly, nonatomic) NSURL *containerURL;
@property (readonly, nonatomic) NSURL *localURL;
@property (nonatomic/*, getter = isCloudEnabled*/) BOOL cloudEnabled;

@property (strong, nonatomic) NSArray *fileList;
@property (strong, nonatomic) NSMutableDictionary *urlsForFileNames;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UITextField *nameText;

-(void)getLocalFiles;

@end


@implementation VANIntroViewControllerPad

@synthesize fileList = _fileList;

- (NSURL*)containerURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        url = [[NSFileManager defaultManager]
               URLForUbiquityContainerIdentifier:nil];
    });
    
    return url;
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

-(BOOL)isCloudEnabled {
    return self.containerURL != nil;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    //Temporary//
    self.cloudEnabled = NO;
    //End Temporary//
    
    
    self.newLoad = YES;
    
    self.fileList = [NSArray array];
    
    [self getLocalFiles];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews {
    if (self.newLoad) {
        CGRect startFromTableFrame = CGRectMake(0,0,0,0);
        CGRect startLogoFrame = CGRectMake(0,0,0,0);
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            startFromTableFrame = CGRectMake(self.view.frame.size.width, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            startFromTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        }
        [self.eventsTable setFrame:startFromTableFrame];
        [self.logoImage setFrame:startLogoFrame];
    } else {
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.newLoad) {
    //Animate the TableView into view. Simlar to the Dropbox Intro
    [UIView animateWithDuration:1 animations:^{
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
        self.newLoad = NO;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect toTableFrame = CGRectMake(0,0,0,0);
    CGRect toLogoFrame = CGRectMake(0,0,0,0);
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
        toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth, logoWidth);
    } else {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
        toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
    }
    [UIView animateWithDuration:1 animations:^{
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAppSettings"]) {
        VANFullNavigationViewController *controller = [segue destinationViewController];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        VANAppSettingsViewController *settingsController = (VANAppSettingsViewController *)[controller topViewController];
        settingsController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"toEventSettings"]) {
        VANFullNavigationViewController *nav = [segue destinationViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        VANSettingTabsControllerPad *tabBarController = (VANSettingTabsControllerPad *)[nav topViewController];
        tabBarController.delegate = tabBarController;
        tabBarController.event = sender;
        tabBarController.selectedIndex = 0;
        VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
        controller.event = tabBarController.event;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - Table View Data Source Methods 

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Existing Events";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.fileList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
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
                event = [self createNewEventForContext:context];
            } else {
                if ([eventResults count] > 1) {
                    NSLog(@"WARNING! There are two events in this document");
                }
            
                event = [eventResults firstObject];
            }
            [self performSegueWithIdentifier:@"pushToMain" sender:event];
        }
    }];
    
}

-(Event *)createNewEventForContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:managedObjectEvent inManagedObjectContext:context];
    Event *newEvent = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    return newEvent;
}

#pragma mark - Popover View Controller Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

#pragma mark - Get File Methods

-(void)getLocalFiles
{
    // get all the files
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
    NSMutableArray* fileNames =
    [NSMutableArray arrayWithCapacity:[contents count]];
    
    self.urlsForFileNames =
    [NSMutableDictionary dictionaryWithCapacity:
     [contents count]];

    for (NSURL* url in contents) {
        
        NSString* fileName = [url lastPathComponent];
        NSString* presentedName = [fileName stringByReplacingCharactersInRange:[fileName rangeOfString:fileNameType] withString:@""];
        [fileNames addObject:presentedName];
        [self.urlsForFileNames setValue:url
                                 forKey:fileName];
        
    }
    self.fileList = [NSArray arrayWithArray:fileNames];
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
    
    NSLog(@"%@",url);
    
    // if we don't have a valid URL, create a local url
    if (url == nil) {
        url = [self.localURL URLByAppendingPathComponent:fileNameFull];
        url = [url URLByStandardizingPath];
        [self.urlsForFileNames setValue:url forKey:fileNameFull];
    }
    NSLog(@"%@",url);
    
    // Now Create our document
    VANTryoutDocument* document = [[VANTryoutDocument alloc] initWithFileURL:url];
    
    
    document.persistentStoreOptions = options;
    
    return document;
}

#pragma mark - Create New File
-(void)closePopoverFromSave {
    if ([self.nameText hasText]) {  //If we have a valid Name
        NSString *startingFileName = self.nameText.text;
        //Dismiss Popover
        [self.popover dismissPopoverAnimated:YES];
        self.nameText = nil;

        NSString *fileName = [NSString stringWithFormat:@"%@%@",startingFileName, fileNameType];
        
        NSURL *documentURL = [self.localURL URLByAppendingPathComponent:fileName];
        VANTryoutDocument *newDocument = [self createDocument:startingFileName];
        
        
        [newDocument saveToURL:documentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (!success) {
                [[NSFileManager defaultManager] removeItemAtURL:documentURL error:nil];
                return;
            }
            
            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.fileList count] inSection:0]];
            
            self.fileList = [self.fileList arrayByAddingObject:startingFileName];
            
            [self.eventsTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [newDocument openWithCompletionHandler:^(BOOL successful) {
                if (!successful) {
                    [NSException raise:NSGenericException format:@"Could Not Open File %@", fileName];
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
                    event.name = startingFileName;
                    [self performSegueWithIdentifier:@"pushToMain" sender:event];
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
        
    } else {
        [self.nameText becomeFirstResponder];
        VANTeamColor *color = [[VANTeamColor alloc] init];
        self.nameText.layer.borderColor = [[color findTeamColor] CGColor];
        self.nameText.borderStyle = UITextBorderStyleLine;
    }
}

-(void)closeAndCancelPopover {
    [self.popover dismissPopoverAnimated:YES];
}

-(void)addEvent:(id)sender {
    UIViewController *view = [[UIViewController alloc] init];
    
    [view.view setFrame:CGRectMake(0, 0, 200, 800)];
    
    //Create subviews for View Controller
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(popoverMargins, popoverMargins, popoverWidth-(popoverMargins*2), popoverElementHeight)];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight*2)+(popoverMargins*3)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight*3)+(popoverMargins*4)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    self.nameText = [[UITextField alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight)+(popoverMargins*2)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    
    //Insert Subviews to ViewController
    [view.view insertSubview:label atIndex:0];
    [view.view insertSubview:self.nameText atIndex:0];
    [view.view insertSubview:saveButton atIndex:1];
    [view.view insertSubview:cancelButton atIndex:1];
    
    //Customize Label
    label.text = @"Create a New Event";
    label.textAlignment = NSTextAlignmentCenter;
    
    //Customize Text Field
    self.nameText.backgroundColor = [UIColor whiteColor];
    self.nameText.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);

    //Customize Save Button
    [saveButton setTitle:@"Create Event" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(closePopoverFromSave) forControlEvents:UIControlEventTouchUpInside];
    VANTeamColor *color = [[VANTeamColor alloc] init];
    saveButton.backgroundColor = [color findTeamColor];
    
    //Customize Cancel Button
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeAndCancelPopover) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor lightGrayColor];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:view];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(popoverWidth, ([view.view.subviews count]*popoverElementHeight)+([view.view.subviews count]*popoverMargins)+popoverMargins);
    [self.popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width-50, 0, 50, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.nameText becomeFirstResponder];
}

#pragma mark Text Field Delegate Methods


@end
