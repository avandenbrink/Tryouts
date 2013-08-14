//
//  VANTagsTableViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTagsTableViewController.h"
#import "VANAddTagCell.h"
#import "AthleteTags.h"

static NSString *kTagNameKey = @"value";
static NSString *kTagCountKey = @"count";
static NSString *kTagTypeKey = @"type";

@interface VANTagsTableViewController ()

@property (nonatomic) NSDictionary *duplicateTag;
@property (nonatomic) NSDictionary *foundTag;
- (NSString *)dataFilePathforPath:(NSString *)string;
- (NSMutableArray *)getPlistFileForResource:(NSString *)resource;

@end

@implementation VANTagsTableViewController

- (void)viewDidLoad {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = cancel;
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamColor findTeamColor]];
    self.tagsArray = [self getPlistFileForResource:@"tags"];
    NSSortDescriptor *sortDescriptorCount = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    [self.tagsArray sortUsingDescriptors:@[sortDescriptorCount,sortDescriptorName]];
    self.selectedTagsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.tagsArray count]; i++) {
        BOOL selected = [self findSelectedString:[self.tagsArray objectAtIndex:i] inManagedObjectArray:[self.athlete.aTags allObjects]];
        if (selected) {
            [self.selectedTagsArray addObject:[self.tagsArray objectAtIndex:i]];
            [self.tagsArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    if ([self.selectedTagsArray count] != [self.athlete.aTags count]) {
        [self cleanupSelectedTags];
    }
}

- (void)done {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)searchThroughArrayOfDicts:(NSArray *)array forTag:(AthleteTags *)tag {
    for (NSInteger i = 0; i < [array count]; i++) {
        NSDictionary *dic = [self.selectedTagsArray objectAtIndex:i];
        if ([[dic valueForKey:kTagNameKey] isEqualToString:tag.descriptor]) {
            return YES;
        }
    }
    return NO;
}

- (void)cleanupSelectedTags {
    NSLog(@"Warning: SelectedTags is different from athlete.aTags");
    NSArray *tags = [self.athlete.aTags allObjects];
    
    if ([self.selectedTagsArray count] > [tags count]) {
        NSLog(@"Selected is Greater than aTags");
        for (NSInteger i = 0; i < [self.selectedTagsArray count]; i++) {
            NSDictionary *dic = [self.selectedTagsArray objectAtIndex:i];
            for (NSInteger x = 0; x < [tags count]; x++) {
                AthleteTags *tag = [tags objectAtIndex:x];
                if ([tag.descriptor isEqualToString:[dic valueForKey:kTagNameKey]]) {
                    NSLog(@"String Not Registered: %@", [dic valueForKey:kTagNameKey]);
                } else {
        }   }   }
    } else {
        NSLog(@"aTags is Greater than selected");
        for (NSInteger i = 0; i < [tags count]; i++) {
            AthleteTags *tag = [tags objectAtIndex:i];
            BOOL exists = [self searchThroughArrayOfDicts:self.selectedTagsArray forTag:tag];
            if (!exists) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[tag.descriptor, [NSNumber numberWithInt:1], tag.type] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
                [self.selectedTagsArray addObject:dictionary];
    }   }   }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *datafile = [self dataFilePathforPath:@"tags.plist"];
    NSLog(@"%@", datafile);
    NSArray *masterArray = [self.selectedTagsArray arrayByAddingObjectsFromArray:self.tagsArray];
    [masterArray writeToFile:datafile atomically:YES];
}

#pragma mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.selectedTagsArray count];
    } else {
        return [self.tagsArray count]+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Build New Tag Cell Here
        VANAddTagCell *cell = (VANAddTagCell *)[tableView dequeueReusableCellWithIdentifier:@"add"];
        cell.controller = self;
        cell.addNewButton.enabled = NO;
        cell.segmentButton.hidden = YES;
        return cell;
    } else {
        static NSString *cellID = @"tag";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        NSDictionary *dic = [NSDictionary dictionary];
        if (indexPath.section == 0) {
            dic = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
 //           VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        } else {
            dic = [self.tagsArray objectAtIndex:indexPath.row-1];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([dic valueForKey:kTagTypeKey] == [NSNumber numberWithInt:0]) {
            cell.imageView.image = [UIImage imageNamed:@"upArrow.png"];
        } else if ([dic valueForKey:kTagTypeKey] == [NSNumber numberWithInt:2]) {
            cell.imageView.image = [UIImage imageNamed:@"downArrow.png"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"neutral.png"];
        }
        
        
        cell.textLabel.text = [dic valueForKey:kTagNameKey];

        
        return cell;
    }
}

#pragma mark - TableView DataSource Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        VANAddTagCell *cell = (VANAddTagCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.addNewButton.enabled = YES;
        cell.segmentButton.hidden = NO;
        [cell.textView becomeFirstResponder];
    } else {
        if (indexPath.section == 0) {
            NSDictionary *dic = [self.selectedTagsArray objectAtIndex:indexPath.row];
            AthleteTags *tag = [self returnManagedObjectwithString:[dic valueForKey:kTagNameKey] fromSet:self.athlete.aTags];
            [self removeTagFromAthleteProfile:tag];
            [self.selectedTagsArray removeObjectAtIndex:indexPath.row];
            [self.tagsArray addObject:dic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:[self.tagsArray count] inSection:1]];
        } else {
            NSDictionary *dic = [self.tagsArray objectAtIndex:indexPath.row-1];
            NSNumber *count = [dic valueForKey:kTagCountKey];
            [dic setValue:[NSNumber numberWithInt:[count intValue]+1] forKey:kTagCountKey];
            [self addNewTagToAthleteProfile:dic];
            [self.tagsArray removeObjectAtIndex:indexPath.row-1];
            [self.selectedTagsArray addObject:dic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0]];
            
        }
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *string = [NSString stringWithFormat:@"%@'s characteristics:",self.athlete.name];
        return string;
    } else {
        return @"Other tags:";
    }
}

- (BOOL)seeIfTagExists:(NSDictionary *)dic {
    NSArray *fullArray = [self.selectedTagsArray arrayByAddingObjectsFromArray:self.tagsArray];
    for (NSInteger i = 0; i < [fullArray count]; i++) {
        NSDictionary *tags = [fullArray objectAtIndex:i];
        if ([[tags valueForKey:kTagNameKey] isEqualToString:[dic valueForKey:kTagNameKey]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tag Already Exists" message:@"Continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",@"Replace", nil];
            self.duplicateTag = dic;
            self.foundTag = tags;
            [alert show];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Custom Methods
//Works with the VANAddCollectionTagCell, and is called by this cell when the user taps the Add button to confirm the new tags description
-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[string, [NSNumber numberWithInt:1], [NSNumber numberWithInteger:type]] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
    
    BOOL exists = [self seeIfTagExists:dict];
    
    if (!exists) {
        //First Add the New Tag to the Selected Tags for the Specified Athlete, which involves adding the string name to self.selectedTagsArray and creating a new AthleteTags managed object with a relationship to self.athlete
        [self addNewTagToAthleteProfile:dict];
        [self.selectedTagsArray addObject:dict];
        NSLog(@"Build- Name: %@, Count: %@, Type: %@", [dict valueForKey:kTagNameKey], [dict valueForKey:kTagCountKey], [dict valueForKey:kTagTypeKey]);
        
        //Add new Cell to the CollectionView
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //Second Revert the size of the AddTagCell to its original 35 x 35 size, disable the button, and resign the text fields first responder status
        
        //Third add the New Tag description to the Characteristics Plist for future use
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { //First Button is Continue
        for (NSInteger i = 0; i <  [self.tagsArray count]; i++) {
            NSDictionary *dic = [self.tagsArray objectAtIndex:i];
            if ([[dic valueForKey:kTagNameKey] isEqualToString:[self.foundTag valueForKey:kTagNameKey]]) {
                [self.selectedTagsArray addObject:dic];
                [self addNewTagToAthleteProfile:dic];
                [self.tagsArray removeObjectAtIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
                [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:1] toIndexPath:indexPath];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }
        }
    } else if (buttonIndex == 2) { // Replace is clicked
        for (NSInteger i = 0; i <  [self.tagsArray count]; i++) {
            NSDictionary *dic = [self.tagsArray objectAtIndex:i];
            if ([[dic valueForKey:kTagNameKey] isEqualToString:[self.foundTag valueForKey:kTagNameKey]]) {
                [self.selectedTagsArray addObject:self.duplicateTag];
                [self addNewTagToAthleteProfile:self.duplicateTag];
                [self.tagsArray removeObjectAtIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
                [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:1] toIndexPath:indexPath];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                if ([self.duplicateTag valueForKey:kTagTypeKey] == [NSNumber numberWithInt:0]) {
                    cell.imageView.image = [UIImage imageNamed:@"upArrow.png"];
                } else if ([self.duplicateTag valueForKey:kTagTypeKey] == [NSNumber numberWithInt:2]) {
                    cell.imageView.image = [UIImage imageNamed:@"downArrow.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"neutral.png"];
                }
            }
        }
    } else { //Cancel is Clicked
        NSLog(@"Cancel");
    }
    self.duplicateTag = nil;
    self.foundTag = nil;
}

-(void)PlistAddTagWithString:(NSString*)string andType:(NSString*)type {
    NSMutableArray *plist = [self getPlistFileForResource:@"tags"];
    NSDictionary *newTag = [NSDictionary dictionaryWithObjects:@[string, type, [NSNumber numberWithInt:1]] forKeys:@[kTagNameKey, kTagTypeKey, kTagCountKey]];
    [plist addObject:newTag];
    
}

//Works with this Controllers DidSelectCellatIndex Method to cycle through all of the currently selected Athlete tags to make sure that we have the correct value before removing it from the athlete's profile
- (AthleteTags *)returnManagedObjectwithString:(NSString *)string fromSet:(NSSet *)set {
    for (AthleteTags *tag in set) {
        if ([tag.descriptor isEqualToString:string]) {
            return tag;
        }
    }
    NSLog(@"Error: Reached the end of Array without finding a Match");
    return nil;
}

//Works with this Controller's View did load method to cycle through each of the items in self.tags array to determine if they are already also represented in the athlete's profile, if so it is returned
- (BOOL)findSelectedString:(NSDictionary *)dict inManagedObjectArray:(NSArray *)array {
    for (NSInteger i = 0; i < [array count]; i++) {
        AthleteTags *tag = [array objectAtIndex:i];
        if ([[dict valueForKey:kTagNameKey] isEqualToString:tag.descriptor]) {
            return YES;
        }
    }
    return NO;
}

//Works with this Controller's ViewDidLoad method to extract the string values of all of the AthelteTag managed objects that are currently represented in the Athlete profile, returning them all in an Array
- (NSMutableArray *)arrayOfStringsForManagedObjectSet:(NSSet *)set withStringDescription:(NSString *)string {
    NSArray *objectArray = [set allObjects];
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [set count]; i++) {
        NSManagedObject *object = [objectArray objectAtIndex:i];
        [returnArray addObject:[object valueForKey:string]];
    }
    return returnArray;
}

//Expired method that used to work with this controller to search an array of strings for a specific string, expired becuase architecture has been updated to create an array of Dictionaries, with more detailed information on each tag, rather than simple string values.
-(BOOL)searchThroughArray:(NSArray *)array forString:(NSString *)string {
    for (NSInteger i = 0; i < [array count]; i++) {
        AthleteTags *tag = [array objectAtIndex:i];
        if ([string isEqualToString:tag.descriptor]) {
            return YES;
        }
    }
    return NO;
}

//Works with this Controller's didSelectItemAtIndex methods to create a new AthleteTag instance from the self.athlete managedObjectContext
//Currently saves the Context after each iteration, but may not be the most efficient appraoch.
- (void)addNewTagToAthleteProfile:(NSDictionary *)dict {
    NSMutableSet *relationshipSet = [self.athlete mutableSetValueForKey:@"aTags"];
    
    NSEntityDescription *entity = [self.athlete entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:@"aTags"];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    AthleteTags *tag = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:[self.athlete managedObjectContext]];
    [relationshipSet addObject:tag];
    tag.descriptor = [dict valueForKey:kTagNameKey];
    tag.type = [dict valueForKey:kTagTypeKey];
    [self saveManagedObjectContext:self.athlete];
}

//Works with this Controller's didSelectItemAtIndex method to remove an AthleteTag instance and its relationship to self.athlete from the managedObjectContext
- (void)removeTagFromAthleteProfile:(NSManagedObject *)object {
    NSManagedObjectContext *context = [self.athlete managedObjectContext];
    [context deleteObject:object];
}

//Returns a string value of the full filepath for a file with name of the input value "sting"
- (NSString *)dataFilePathforPath:(NSString *)string {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:string];
}

//Works with this Controller's viewDidLoad method to return a NSMutableArray object from a plistFile in the NSDocumentDirectory Bundle named Characteristics.plist
//If the file does not exist, it pulls a default plist file from the mainBundle that was created by our developers to be a starting point for the user
- (NSMutableArray *)getPlistFileForResource:(NSString *)resource {
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", resource];
    NSString *filePath = [self dataFilePathforPath:dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"CharacteristicsDefault" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"Characteristics"]];
        NSLog(@"Returning default array");
        [array writeToFile:filePath atomically:YES];
        return array;
    } else {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
        NSLog(@"File Path: %@", filePath);
    }
}

@end
