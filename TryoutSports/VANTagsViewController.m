//
//  VANTagsPopoverViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VANTagsViewController.h"
#import "VANTagsCollectionCell.h"
#import "VANAddCollectionTagCell.h"
#import "AthleteTags.h"
#import "VANLeftAlignedFlowLayout.h"

static NSString *kTagNameKey = @"value";
static NSString *kTagCountKey = @"count";
static NSString *kTagTypeKey = @"type";

@interface VANTagsViewController ()

- (NSString *)dataFilePathforPath:(NSString *)string;
- (NSMutableArray *)getPlistFileForResource:(NSString *)resource;

@property (nonatomic) BOOL addingTag;

@end

@implementation VANTagsViewController

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
    
//    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@" "];
//    self.selectedTagsArray = [[NSMutableArray alloc] initWithArray:[self.athlete.aTags allObjects]];
//    self.tagsArray = [[NSMutableArray alloc] initWithArray:[[self.event.tests allObjects] filteredArrayUsingPredicate:tagPred]];    
//    for (NSInteger i = 0; i < [array count]; i++) {
//        BOOL isSelected = [self searchAthleteTagsForTag:[array objectAtIndex:i]];
//        if (isSelected) {
//            [self.selectedTagsArray addObject:[array objectAtIndex:i]];
//        } else {
//            [self.tagsArray addObject:[array objectAtIndex:i]];
//        }
//    }
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
                if ([[tags objectAtIndex:x] isEqualToString:[dic valueForKey:kTagNameKey]]) {
                    NSLog(@"String Not Registered: %@", [dic valueForKey:kTagNameKey]);
                } else {
                    
                }
            }
        }
    } else {
        NSLog(@"aTags is Greater than selected");
        for (NSInteger i = 0; i < [tags count]; i++) {
            AthleteTags *tag = [tags objectAtIndex:i];
            BOOL exists = [self searchThroughArrayOfDicts:self.selectedTagsArray forTag:tag];
            if (!exists) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[tag.descriptor, [NSNumber numberWithInt:1], tag.type] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
                [self.selectedTagsArray addObject:dictionary];
            }
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    NSString *datafile = [self dataFilePathforPath:@"tags.plist"];
    NSLog(@"%@", datafile);
    NSArray *masterArray = [self.selectedTagsArray arrayByAddingObjectsFromArray:self.tagsArray];
    [masterArray writeToFile:datafile atomically:YES];
}

#pragma mark - CollectionView Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
    // See AAA above/
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 //   return [self.tagsArray count];
    // See AAA above
    
    
  if (section == 0) {
        return [self.selectedTagsArray count];
    } else {
        return [self.tagsArray count]+1;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *cel = @"add";
        VANAddCollectionTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cel forIndexPath:indexPath];
        cell.controller = self;
        cell.layer.cornerRadius = 10.00f;
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    } else {
        NSString *CellIdentifier = @"tag";
        VANTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.layer.cornerRadius = 10.00f;
        cell.label.textColor = [UIColor whiteColor];
        cell.label.font = [UIFont systemFontOfSize:22];
        NSNumber *type = nil;
        if ([indexPath section] == 0) {
            if ([self.athlete.aTags count] == 0) {
                cell.label.text = @"None Selected";
                cell.frame = CGRectMake(0, 0, 260, 25);
            } else {
                cell.label.text = [[self.selectedTagsArray objectAtIndex:indexPath.row] valueForKey:kTagNameKey];
                VANTeamColor *teamColor = [[VANTeamColor alloc] init];
                cell.backgroundColor = [teamColor findTeamColor];
                type = [[self.selectedTagsArray objectAtIndex:indexPath.row] valueForKey:kTagTypeKey];
            }
        } else {
            cell.label.text = [[self.tagsArray objectAtIndex:indexPath.row-1] valueForKey:kTagNameKey];
            cell.backgroundColor = [UIColor lightGrayColor];
            type = [[self.tagsArray objectAtIndex:indexPath.row-1] valueForKey:kTagTypeKey];
        }
        NSLog(@"Type: %@", type);
        if (type == [NSNumber numberWithInt:0]) {
            UIImage *upArrow = [UIImage imageNamed:@"upArrow.png"];
            cell.typeImage.image = upArrow;
        } else if (type == [NSNumber numberWithInteger:2]) {
            UIImage *downArrow = [UIImage imageNamed:@"downArrow.png"];
            cell.typeImage.image = downArrow;
        } else {
            UIImage *neutral = [UIImage imageNamed:@"neutral.png"];
            cell.typeImage.image = neutral;
        }
        return cell;
    }

}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] != 1) {
        return nil;
    } else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 275, 30)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"Add:";
        [view addSubview:label];
        return view;
    }
}


#pragma mark - CollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (!self.addingTag) {
            
            // Prepare for animation
            [collectionView.collectionViewLayout invalidateLayout];
            VANAddCollectionTagCell *cell = (VANAddCollectionTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
            void (^animateChangeWidth)() = ^()
            {
                __block UICollectionViewCell *blockCell = cell;  // Avoid a retain cycle
                NSLog(@"Running Animation");
                // Do the animation
                CGRect frame = blockCell.frame;
                frame.size = CGSizeMake(302, 40);
                blockCell.frame = frame;
                self.addingTag = YES;
                cell.addButton.enabled = YES;
                
                //self.view.center
                //Need to determin number of row in section 1, to determin how far down the scroll view must be diverted to be vissible when the keyboard pops up
            };
        
            // Animate
            [UIView transitionWithView:cell duration:0.3f options: UIViewAnimationOptionCurveLinear animations:animateChangeWidth completion:nil];
            [cell.textField becomeFirstResponder];
        } else {
            NSLog(@"Already Ran Animation to build ");
        }
    } else {
        VANTagsCollectionCell *cell = (VANTagsCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (indexPath.section == 0) {
            AthleteTags *tag = [self returnManagedObjectwithString:cell.label.text fromSet:self.athlete.aTags];
            if (!tag) {
                NSLog(@"Warning No Tag Exists");
            }
            [self removeTagFromAthleteProfile:tag];
            NSDictionary *dict = [self.selectedTagsArray objectAtIndex:indexPath.row];
            NSLog(@"Name: %@, Count: %@, Type: %@", [dict valueForKey:kTagNameKey], [dict valueForKey:kTagCountKey], [dict valueForKey:kTagTypeKey]);
            [self.tagsArray addObject:dict];
            [self.selectedTagsArray removeObjectAtIndex:indexPath.row];
            [self.collection moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:[self.tagsArray count] inSection:1]];
            cell.backgroundColor = [UIColor lightGrayColor];
        } else {
            NSMutableDictionary *dict = [self.tagsArray objectAtIndex:indexPath.row-1];
            [self addNewTagToAthleteProfile:dict];
            NSNumber *count = [dict valueForKey:kTagCountKey];
            NSLog(@"1- Name: %@, Count: %@, Type: %@", [dict valueForKey:kTagNameKey], [dict valueForKey:kTagCountKey], [dict valueForKey:kTagTypeKey]);
       //Trouble Line right here : only seems to be a problem with NEW tags
            //[dict setObject:[NSNumber numberWithInt:[count intValue] + 1] forKey:kTagCountKey];
            [dict setValue:[NSNumber numberWithInt:[count intValue]+1] forKey:kTagCountKey];
            NSLog(@"2- Name: %@, Count: %@, Type: %@", [dict valueForKey:kTagNameKey], [dict valueForKey:kTagCountKey], [dict valueForKey:kTagTypeKey]);
            [self.selectedTagsArray addObject:dict];
            [self.tagsArray removeObjectAtIndex:indexPath.row-1];
            VANTeamColor *teamColor = [[VANTeamColor alloc] init];
            cell.backgroundColor = [teamColor findTeamColor];
            [self.collection moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:[self.athlete.aTags count]-1 inSection:0]];
        }
    }
}

#pragma mark - CollectionView Layout Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(9, 9, 9, 9);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.addingTag) {
            return CGSizeMake(302, 45);
        } else {
            return CGSizeMake(35, 35);
        }
    } else {
        NSString *tag = nil;
        if (indexPath.section == 0) {
            NSLog(@"Runnign through Layout of Collection View");
            tag = [[self.selectedTagsArray objectAtIndex:indexPath.row] valueForKey:kTagNameKey];
        } else {
            tag = [[self.tagsArray objectAtIndex:(indexPath.row-1)] valueForKey:kTagNameKey];
        }
        CGSize textSize = [tag sizeWithAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:17]] forKeys:@[NSFontAttributeName]]];
        return CGSizeMake(textSize.width + 24 + 18, textSize.height + 8);
    }
}

#pragma mark - Custom Methods
//Works with the VANAddCollectionTagCell, and is called by this cell when the user taps the Add button to confirm the new tags description
-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[string, [NSNumber numberWithInt:1], [NSNumber numberWithInteger:type]] forKeys:@[kTagNameKey, kTagCountKey, kTagTypeKey]];
    //First Add the New Tag to the Selected Tags for the Specified Athlete, which involves adding the string name to self.selectedTagsArray and creating a new AthleteTags managed object with a relationship to self.athlete
    [self addNewTagToAthleteProfile:dict];
    [self.selectedTagsArray addObject:dict];
    NSLog(@"Build- Name: %@, Count: %@, Type: %@", [dict valueForKey:kTagNameKey], [dict valueForKey:kTagCountKey], [dict valueForKey:kTagTypeKey]);

    //Add new Cell to the CollectionView
    NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[self.selectedTagsArray count]-1 inSection:0];
    [self.collection insertItemsAtIndexPaths:@[newIndex]];
    
    //Second Revert the size of the AddTagCell to its original 35 x 35 size, disable the button, and resign the text fields first responder status
    [self closeNewTagCell];
    
    //Third add the New Tag description to the Characteristics Plist for future use
    
}

-(void)PlistAddTagWithString:(NSString*)string andType:(NSString*)type {
    NSMutableArray *plist = [self getPlistFileForResource:@"tags"];
    NSDictionary *newTag = [NSDictionary dictionaryWithObjects:@[string, type, [NSNumber numberWithInt:1]] forKeys:@[kTagNameKey, kTagTypeKey, kTagCountKey]];
    [plist addObject:newTag];

}

-(void)closeNewTagCell {
    if (self.addingTag) {
        
        // Prepare for animation
        NSIndexPath *tagCellIndex = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.collection.collectionViewLayout invalidateLayout];
        VANAddCollectionTagCell *cell = (VANAddCollectionTagCell *)[self.collection cellForItemAtIndexPath:tagCellIndex];
        void (^animateChangeWidth)() = ^()
        {
            __block UICollectionViewCell *blockCell = cell;  // Avoid a retain cycle
            NSLog(@"Running Animation");
            // Do the animation
            CGRect frame = blockCell.frame;
            frame.size = CGSizeMake(35, 35);
            blockCell.frame = frame;
            
            //Make changes to Cell Components
            cell.segmentControl.selectedSegmentIndex = 1;
            
            cell.addButton.enabled = NO;
            cell.textField.text = @"";
            [cell.textField resignFirstResponder];
            
            //Need to determin number of row in section 1, to determin how far down the scroll view must be diverted to be vissible when the keyboard pops up
        };
        
        // Animate
        [UIView transitionWithView:cell duration:0.3f options: UIViewAnimationOptionCurveLinear animations:animateChangeWidth completion:nil];
        self.addingTag = NO;
    } else {
        NSLog(@"Already Ran Animation to build ");
    }
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

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
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
