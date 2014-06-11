//
//  VANManagedObjectTableViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectTableViewController.h"



@interface VANManagedObjectTableViewController ()

@end

@implementation VANManagedObjectTableViewController

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VANTeamColor *teamcolor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamcolor findTeamColor]];
        
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Custom Methods

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
    NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:key];
    NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
    [relationshipSet removeObject:relationshipObject];
    [self saveManagedObjectContext:self.event];
}

-(void)adjustContentInsetsForEditing:(BOOL)editing {
    //Can be OverWriten If Needed in SubClasses
}

-(NSManagedObject *)addNewRelationship:(NSString *)relationship toManagedObject:(NSManagedObject *)managedObject andSave:(BOOL)save {
    
    NSMutableSet *relationshipSet = [managedObject mutableSetValueForKey:relationship];
    NSEntityDescription *entity = [managedObject entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:relationship];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:managedObject.managedObjectContext];
    [relationshipSet addObject:newManagedObject];
    if (save) {
        [self saveManagedObjectContext:managedObject];
        
    }
    return newManagedObject;
}

-(void)addTextFieldContent:(NSString *)content ToContextForTitle:(NSString *)title {
    
}
@end
