//
//  VANTagsTableDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTagsTableDelegate.h"
#import "VANGlobalMethods.h"

#import "Athlete.h"
#import "Event.h"
#import "AthleteTags.h"

#import "VANAddTagCell.h"
#import "VANFilterButtonCell.h"


static NSString *tagsFileName = @"tags";


static NSString *kTagNameKey = @"value";
static NSString *kTagCountKey = @"count";
static NSString *kTagTypeKey = @"type";

@interface VANTagsTableDelegate ()

@property (strong, nonatomic) UISegmentedControl *filterSegment;

@property (strong, nonatomic) NSMutableArray *selectedTagsArray;
@property (strong, nonatomic) NSMutableArray *otherTagsArray;
@property (strong, nonatomic) NSMutableArray *masterTagsArray;

@property (nonatomic) NSDictionary *duplicateTag;
@property (nonatomic) NSDictionary *foundTag;
@property (nonatomic,strong) NSMutableArray *unFilterTagsArray;

@property (nonatomic, strong) VANAddTagCell *tagCell;

@end

@implementation VANTagsTableDelegate


- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        [self setup];
        self.tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

-(void)setup {
    //place future setup code here.
    _masterTagsArray = [self getPlistFileForResource:tagsFileName];
}


#pragma mark - Refresh the TableView Data Methods


-(void)filterTagArraysWithAthlete:(Athlete *)athlete
{
    self.athlete = athlete;
    
    if (!_masterTagsArray) {
        _masterTagsArray = [self getPlistFileForResource:tagsFileName];
    }
    
    _selectedTagsArray = [NSMutableArray array];
    _otherTagsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [_masterTagsArray count]; i++) {
        BOOL selected = [self findSelectedString:[_masterTagsArray objectAtIndex:i] inManagedObjectArray:[self.athlete.aTags allObjects]];
        if (selected) {
            [_selectedTagsArray addObject:[_masterTagsArray objectAtIndex:i]];
        } else {
            [_otherTagsArray addObject:[_masterTagsArray objectAtIndex:i]];
        }
    }
    
    NSSortDescriptor *sortDescriptorCount = [[NSSortDescriptor alloc] initWithKey:kTagCountKey ascending:NO];
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:kTagNameKey ascending:YES];
    [_otherTagsArray sortUsingDescriptors:@[sortDescriptorCount,sortDescriptorName]];
    [_selectedTagsArray sortedArrayUsingDescriptors:@[sortDescriptorName]];
    
    
    _filterSegment.selectedSegmentIndex = 0;
}

-(void)resetTagsFiltertoAll {
    _filterSegment.selectedSegmentIndex = 0;
}

-(void)saveMasterTagsArrayToFile
{
    NSString *file = [self getPlistFilePathForSimpleFileName:tagsFileName];
    if ([_masterTagsArray count] > 0) {
        [_masterTagsArray writeToFile:file atomically:YES];
        NSLog(@"Saving File");
    } else {
        NSLog(@"Error Saving Tags File, _masterTagsArray is misplaced");
    }
}

- (BOOL)searchThroughArrayOfDicts:(NSArray *)array forTag:(AthleteTags *)tag
{
    for (NSInteger i = 0; i < [array count]; i++) {
        NSDictionary *dic = [self.selectedTagsArray objectAtIndex:i];
        if ([[dic valueForKey:kTagNameKey] isEqualToString:tag.descriptor]) {
            return YES;
        }
    }
    return NO;
}

- (void)cleanupSelectedTags
{
    NSLog(@"Warning: SelectedTags is different from athlete.aTags");
    
    NSMutableArray *tags = [(NSMutableArray *)[self.athlete.aTags allObjects] mutableCopy];
    NSMutableArray *tagStrings = [NSMutableArray array];
    for (int i = 0; i < [tags count]; i++) {
        AthleteTags *tag = [tags objectAtIndex:i];
        [tagStrings addObject:tag.descriptor];
    }
    
    NSMutableArray *selected = [_selectedTagsArray mutableCopy];
    NSMutableArray *selectedStrings = [NSMutableArray array];
    for (int i = 0; i < [selected count]; i++) {
        NSDictionary *d = [selected objectAtIndex:i];
        [selectedStrings addObject:[d valueForKey:kTagNameKey]];
    }
    
    NSMutableArray *tagsFinal = [NSMutableArray arrayWithArray:tagStrings];
    [tagsFinal removeObjectsInArray:selectedStrings];
    
    NSMutableArray *selectedFinal = [NSMutableArray arrayWithArray:selectedStrings];
    [selectedFinal removeObjectsInArray:tagStrings];
    
    if ([tagsFinal count] > 0) {
        NSLog(@"Leftover Tags: %@", [tagsFinal description]);
        
        NSMutableArray *reclaim = [NSMutableArray array];
        for (int i = 0; [tagsFinal count]; i++) {
            NSString *string = [tagsFinal objectAtIndex:i];
            
            NSManagedObjectContext *context = self.athlete.managedObjectContext;
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AthleteTags"];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"descriptor == %@", string];
            [request setPredicate:pred];
            NSError *error;
            NSArray *array = [context executeFetchRequest:request error:&error];
            AthleteTags *tag = [array objectAtIndex:0];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[string, [NSNumber numberWithInt:1], tag.type] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
            
            [reclaim addObject:dictionary];
        }
        [self.selectedTagsArray addObjectsFromArray:reclaim];
        [_masterTagsArray addObjectsFromArray:reclaim];
        
        [self saveMasterTagsArrayToFile];
    }
    
    if ([selectedFinal count] > 0) {
        NSLog(@"Leftover Selected: %@", [selectedFinal description]);
    }
}

#pragma mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.selectedTagsArray count];
    } else {
        return [self.otherTagsArray count]+2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *cellID = @"filter";
        VANFilterButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[VANFilterButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        self.filterSegment = cell.segmentControl;
        [self.filterSegment addTarget:self action:@selector(filterChanged) forControlEvents:UIControlEventValueChanged];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        //Build New Tag Cell Here
        VANAddTagCell *cell = (VANAddTagCell *)[tableView dequeueReusableCellWithIdentifier:@"add"];
        
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANAddTagCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.delegate = self;
        cell.addNewButton.enabled = NO;
        cell.segmentButton.hidden = YES;
        _tagCell = cell;
        return cell;
    } else {
        static NSString *cellID = @"tag";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary *dic = [NSDictionary dictionary];
        if (indexPath.section == 0) {
            dic = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            dic = [self.otherTagsArray objectAtIndex:indexPath.row-2];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // Do Nothing --- Filter Button Cell
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        // Add new tag Cell
        _tagCell.addNewButton.enabled = YES;
        _tagCell.segmentButton.hidden = NO;
        [_tagCell.textView becomeFirstResponder];
        
        if ([_delegate respondsToSelector:@selector(VANAddTagCellBecameFirstResponder)]) {
            [_delegate VANAddTagCellBecameFirstResponder];
        }
    } else {
        if (indexPath.section == 0) {
            NSDictionary *dic = [self.selectedTagsArray objectAtIndex:indexPath.row];
            
            AthleteTags *tag = [self returnManagedObjectwithString:[dic valueForKey:kTagNameKey] fromSet:self.athlete.aTags];
            [self removeTagFromAthleteProfile:tag];
            [self.selectedTagsArray removeObjectAtIndex:indexPath.row];
            [self.otherTagsArray addObject:dic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSIndexPath *destination = [NSIndexPath indexPathForRow:[_otherTagsArray count] inSection:1];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:destination];
        } else {
            NSDictionary *dic = [self.otherTagsArray objectAtIndex:indexPath.row-2];
            NSNumber *count = [dic valueForKey:kTagCountKey];
            NSNumber *addOne = [NSNumber numberWithInt:[count intValue]+1];
            [dic setValue:addOne forKey:kTagCountKey];
            [self addNewTagToAthleteProfile:dic];
            [self.otherTagsArray removeObjectAtIndex:indexPath.row-2];
            [self.selectedTagsArray addObject:dic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0]];
        }
        
        if ([_delegate respondsToSelector:@selector(athleteTagProfileHasBeenUpdated)]) {
            NSLog(@"Athlete %lu",(unsigned long)[self.athlete.aTags count]);
            [_delegate athleteTagProfileHasBeenUpdated];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *string = [NSString stringWithFormat:@"%@'s characteristics:",self.athlete.name];
        return string;
    } else {
        return @"Other tags:";
    }
}

#pragma mark - Filter Segment Button Methods

-(void)filterTagsbyType:(NSInteger)integer
{
    NSArray *tempArray = [self.otherTagsArray arrayByAddingObjectsFromArray:self.unFilterTagsArray];
    
    self.otherTagsArray = [NSMutableArray array];
    self.unFilterTagsArray = [NSMutableArray array];
    for (NSDictionary *dic in tempArray) {
        if ([dic valueForKey:kTagTypeKey] == [NSNumber numberWithInteger:integer]) {
            [self.otherTagsArray addObject:dic];
        } else {
            [self.unFilterTagsArray addObject:dic];
        }
    }
}

-(void)filterChanged
{
    if (self.filterSegment.selectedSegmentIndex == 0) { //All Filter
        
        [self.otherTagsArray addObjectsFromArray:self.unFilterTagsArray];
        self.unFilterTagsArray = [NSMutableArray array];
        
    } else if (self.filterSegment.selectedSegmentIndex == 1) { //Good Filter
        [self filterTagsbyType:0];
    } else if (self.filterSegment.selectedSegmentIndex == 2) { //Neutral Filter
        [self filterTagsbyType:1];
    } else { //Bad Filter
        [self filterTagsbyType:2];
    }
    
    NSSortDescriptor *sortDescriptorCount = [[NSSortDescriptor alloc] initWithKey:kTagCountKey ascending:NO];
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:kTagNameKey ascending:YES];
    [self.otherTagsArray sortUsingDescriptors:@[sortDescriptorCount,sortDescriptorName]];
    
    [_tableView reloadData];
}

#pragma mark - VAN Add Tag Delegate Methods

//Works with the VANAddCollectionTagCell, and is called by this cell when the user taps the Add button to confirm the new tags description
-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[string, [NSNumber numberWithInt:1], [NSNumber numberWithInteger:type]] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
    
    NSDictionary *existingDictionary = [self masterContainsDictionaryWithName:string];
    
    if (existingDictionary) {
        self.duplicateTag = dict;
        self.foundTag = existingDictionary;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tag Already Exists" message:@"Replace It?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",@"Use Existing Tag", nil];
        [alert show];
    } else {
        //1. Add the New Tag to the Selected Tags array. (And to Athlete Profile)
        [self addNewTagToAthleteProfile:dict];
        [self.selectedTagsArray addObject:dict];
        
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //2. Add Tag to Tag plist
        [_masterTagsArray addObject:dict];
        [self saveMasterTagsArrayToFile];
        
        //Tell the Cell that It can release its acitve Status
        [_tagCell safeToCloseAddTagCell];
        
        if ([_delegate respondsToSelector:@selector(athleteTagProfileHasBeenUpdated)]) {
            [_delegate athleteTagProfileHasBeenUpdated];
        }
        

    }
}

-(void)VANAddTextViewDidBecomeFirstResponder {
    if ([_delegate respondsToSelector:@selector(VANAddTagCellBecameFirstResponder)]) {
        [_delegate VANAddTagCellBecameFirstResponder];
    }
}

-(void)VANAddTextViewDidResignFirstResponder {
    if ([_delegate respondsToSelector:@selector(VANAddTagCellIsReleasingFirstResponder)]) {
        [_delegate VANAddTagCellIsReleasingFirstResponder];
    }
}

#pragma mark - Alert View Custom Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) { //First Button is Continue
        // will continue by using the existing Tag as it is and adding to Profile
        NSNumber *number = [_foundTag valueForKey:kTagCountKey];
        NSNumber *addOne = [NSNumber numberWithInt:[number intValue]+1];
        [_foundTag setValue:addOne forKey:kTagCountKey];
        
        [self findTagAndUpdateUI];
        
    } else if (buttonIndex == 1) { // Replace is clicked
        // will replace the existing Tag with new one and add it to Profile
        NSNumber *newType = [_duplicateTag valueForKey:kTagTypeKey];
        NSString *newCount = [_duplicateTag valueForKey:kTagCountKey];
        [_foundTag setValue:newType forKey:kTagTypeKey];
        [_foundTag setValue:newCount forKey:kTagCountKey];
        
        [self saveMasterTagsArrayToFile];
        
        [self findTagAndUpdateUI];
    }
    
    self.duplicateTag = nil;
    self.foundTag = nil;
}

-(void)findTagAndUpdateUI
{
    //We will Use _foundTag as it is
    
    //Need to find which active array it is currently sitting in
    BOOL isFound = NO;
    UITableViewCell *cell;
    
    if ([_otherTagsArray containsObject:_foundTag]) {
        isFound = YES;
        [self.selectedTagsArray addObject:_foundTag];
        [self addNewTagToAthleteProfile:_foundTag];
        NSInteger currentIndex = [_otherTagsArray indexOfObject:_foundTag]+2; //+2 because Filter and Add Tag Cells
        [self.otherTagsArray removeObject:_foundTag];
        NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:1];
        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0]; //-1 because [count] starts at 1 not 0
        
        [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:destinationIndexPath];
        cell = [self.tableView cellForRowAtIndexPath:destinationIndexPath];
    }
    
    if (!isFound) {
        if ([_unFilterTagsArray containsObject:_foundTag]) {
            isFound = YES;
            [self.selectedTagsArray addObject:_foundTag];
            [self addNewTagToAthleteProfile:_foundTag];
            [_unFilterTagsArray removeObject:_foundTag];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    if (!isFound) {
        if ([_selectedTagsArray containsObject:_foundTag]) {
            isFound = YES;
            NSInteger index = [_selectedTagsArray indexOfObject:_foundTag];
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    if (!isFound) {
        NSLog(@"Warning: Tag Still not found in Unfiltered Array");
    }
    
    //Update the Cell's UI
    if ([_foundTag valueForKey:kTagTypeKey] == [NSNumber numberWithInt:0]) {
        cell.imageView.image = [UIImage imageNamed:@"upArrow.png"];
    } else if ([_foundTag valueForKey:kTagTypeKey] == [NSNumber numberWithInt:2]) {
        cell.imageView.image = [UIImage imageNamed:@"downArrow.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"neutral.png"];
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    //Give the delegate the opportunity to update its UI
    if ([_delegate respondsToSelector:@selector(athleteTagProfileHasBeenUpdated)]) {
        [_delegate athleteTagProfileHasBeenUpdated];
    }
    
    // OK to proceed and release Tag cell
    [_tagCell safeToCloseAddTagCell];
}


#pragma mark - Other Custom Methods Used

//Searches the MasterTagsArray for a tag with said name and returns a pointer to it if exists
-(NSDictionary *)masterContainsDictionaryWithName:(NSString *)name
{
    for (int i = 1; i < [_masterTagsArray count]; i++) {
        NSDictionary *d = [_masterTagsArray objectAtIndex:i];
        if ([[d valueForKey:kTagNameKey] isEqualToString:name]) {
            return d;
        }
    }
    return nil;
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
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    [methods saveManagedObject:self.athlete];
}

//Works with this Controller's didSelectItemAtIndex method to remove an AthleteTag instance and its relationship to self.athlete from the managedObjectContext
- (void)removeTagFromAthleteProfile:(NSManagedObject *)object {
    NSManagedObjectContext *context = [self.athlete managedObjectContext];
    [context deleteObject:object];
    NSLog(@"Athlete 1 %lu",(unsigned long)[self.athlete.aTags count]);

}

//Works with this Controller's viewDidLoad method to return a NSMutableArray object from a plistFile in the NSDocumentDirectory Bundle named Characteristics.plist
//If the file does not exist, it pulls a default plist file from the mainBundle that was created by our developers to be a starting point for the user
- (NSMutableArray *)getPlistFileForResource:(NSString *)resource {
    NSString *filePath = [self getPlistFilePathForSimpleFileName:resource];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"CharacteristicsDefault" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"Characteristics"]];
        [array writeToFile:filePath atomically:YES];
        return array;
    } else {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
    }
}

//Returns a string value of the full filepath.plist for a file with name of the input value "string"
- (NSString *)getPlistFilePathForSimpleFileName:(NSString *)string
{
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", string];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:dataPath];
    return finalPath;
}

@end
