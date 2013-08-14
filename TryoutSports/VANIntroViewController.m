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


@interface VANIntroViewController ()

@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation VANIntroViewController

@synthesize fetchedResultsController = _fetchedResultsController;

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventsTable.backgroundView = nil;
    self.eventsTable.backgroundColor = [UIColor clearColor];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error loading data", @"Error loading data") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting", @"Error was: %@, quitting"), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alert show];
    }
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.appSettings setTintColor:[teamColor findTeamColor]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.eventsTable reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [[_fetchedResultsController sections] count];
    //if (sections != 0) {
        return sections;
    //} else {
    //    return 1;
    //}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        id<NSFetchedResultsSectionInfo>sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        //if ([sectionInfo numberOfObjects] != 0) {
            return [sectionInfo numberOfObjects];
        //} else {
       //     return 1;
       // }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];

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
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
         
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [_fetchedResultsController objectAtIndexPath:indexPath]; 
    [self performSegueWithIdentifier:@"pushToMain" sender:object];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"We Don't Currently have a Segue by the Name: %@ Sent to IntroViewController", segue.identifier);
}

- (void)appSettingsViewControllerDidFinish:(VANAppSettingsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.appSettings setTintColor:[teamColor findTeamColor]];
    VANFullNavigationViewController *controllers = (VANFullNavigationViewController *)[self navigationController];
    controllers.colorView.backgroundColor = [teamColor findTeamColor];
    [controllers.navigationBar setTintColor:[teamColor findTeamColor]];
    [self.view setNeedsDisplay];
}

- (IBAction)addEvent:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:managedObjectContext];

    [self performSegueWithIdentifier:@"toEventSettings" sender:newEvent];
}



@end
