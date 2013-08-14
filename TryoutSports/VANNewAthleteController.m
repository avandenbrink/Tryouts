//
//  VANNewAthleteController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewAthleteController.h"
#import "VANNewAthleteProfileCell.h"
#import "VANMotherCell.h"
#import "VANTextFieldCell.h"
#import "VANTeamColor.h"
#import "VANPickerCell.h"
#import "VANAthleteListViewController.h"
#import "NewTableConfiguration.h"
#import "VANPictureTaker.h"

static NSString *kDateType = @"Date";
static NSString *kPickerType = @"Picker";

@interface VANNewAthleteController ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) NewTableConfiguration *config;
@property (strong, nonatomic) VANPictureTaker *pictureTaker;

@end

@implementation VANNewAthleteController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.config = [[NewTableConfiguration alloc] init];
    self.config.controller = self;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}
     

-(void)cancel {
    NSManagedObjectContext *context = [self.athlete managedObjectContext];
    [context deleteObject:self.athlete];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)launchCamera:(id)sender {
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
    }
    self.pictureTaker.controller = self;
    [self.pictureTaker callImagePickerController];
}

-(void)placeImage:(UIImage *)image {
    VANNewAthleteProfileCell *cell = (VANNewAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.imageView.image = image;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else {
        if (!self.config.rowZero && !self.config.rowOne) {
            return 4;
        } else {
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    if ([indexPath section] == 0) {
        return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Name" andValue:self.athlete.name orPlaceholder:@"Required" withKeyboard:UIKeyboardTypeAlphabet];
        cellIdentifier = @"TextFieldCell";
        VANTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell initiate];
        cell.label.text = @"Name";
        cell.value = self.athlete.name;
        cell.textField.textAlignment = NSTextAlignmentCenter;
        cell.textField.placeholder = @"Athlete Name";
        return cell;
        
        
    } else if ([indexPath section] == 1) {
        cellIdentifier = @"VANNewAthleteProfileCell";
        VANNewAthleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.athleteName.text = self.athlete.name;
        cell.athleteName.keyboardType = UIKeyboardTypeEmailAddress;
        VANTeamColor *teamcolor = [[VANTeamColor alloc] init];
        cell.athleteHeadshot.backgroundColor = [teamcolor findTeamColor];
        
        cell.stepper.value = [self.event.athletes count];
        cell.athleteNumber.text = [NSString stringWithFormat:@"%1.f", [cell.stepper value]];
        return cell;

    } else {
        if ([indexPath row] == 0) {
            //Birthday Cell
            return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Birthday" andValue:self.athlete.birthday];
        } else if ([indexPath row] == 1) {
            //Position Cell
            if (self.config.rowZero) {
                return [self.config buildDatePickerCellInTable:tableView ForIndex:indexPath forPurpose:@"Birthday"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Position" andValue:self.athlete.position];
            }
        } else if ([indexPath row] == 2 ) {
            if (self.config.rowZero) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Position" andValue:self.athlete.position];
            } else if (self.config.rowOne) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self.event.positions allObjects] forPurpose:@"Position"];
            } else {
            
            return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Email" andValue:self.athlete.email orPlaceholder:@"Email"withKeyboard:UIKeyboardTypeEmailAddress];
        
            }
        } else if ([indexPath row] == 3){
            if ([tableView numberOfRowsInSection:2] == 5) {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Email" andValue:self.athlete.email orPlaceholder:@"Email" withKeyboard:UIKeyboardTypeEmailAddress];
            } else {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Phone Number" andValue:self.athlete.phoneNumber orPlaceholder:@"Number" withKeyboard:UIKeyboardTypeNumbersAndPunctuation];
            }
            
        } else {
            return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Phone Number" andValue:self.athlete.phoneNumber orPlaceholder:@"Number" withKeyboard:UIKeyboardTypeNumbersAndPunctuation];
        }
        /*
            cell.athlete = self.athlete;
            NSArray *values = [self.config valuesForIndexPath:indexPath forSection:[indexPath section]-2];
            if (values != nil) {
                [cell performSelector:@selector(setValues:) withObject:values];
            }
            UIKeyboardType *keyboard = [self.config keyboardTypeForIndexPath:indexPath forSection:[indexPath section] -2];
            if (keyboard != nil) {
            //    cell.textField.keyboardType = *(keyboard);
            }
            
            cell.key = [self.config attributeKeyForIndexPath:indexPath forSection:[indexPath section]-2];
            cell.value = [self.athlete valueForKey:[self.config attributeKeyForIndexPath:indexPath forSection:[indexPath section]-2]];
            cell.label.text = [self.config labelForIndexPath:indexPath forSection:[indexPath section]-2];
            cell.dataType = [self.config dataTypeForIndexPath:indexPath forSection:[indexPath section]-2];
          */          
    }
    // Configure the cell...
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == 1) {
        return 150;
    } else {
        return [self.config setTableViewCellHeightfromTableView:tableView forIndex:indexPath];
    }
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANTextFieldCell class]]) {
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    } else if ([indexPath section] == 2) {
        VANMotherCell *cell = (VANMotherCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.expandable == YES) {
        } else {
            [self.config didSelectRowAtIndex:indexPath inTableView:tableView];
            /*
            if ([indexPath row] == 0) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kDateType];
            } else if ([indexPath row] == 1 && !self.config.rowZero) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kPickerType];
            } else if ([indexPath row] == 2 && self.BirthdayCell == YES) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kPickerType];
            }*/
        }
    }
}



#pragma mark - Custom Self Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"saveToAthleteList"]) {
        VANAthleteListViewController *viewController = segue.destinationViewController;
        viewController.event = self.event;
    }
}
//Build This back together Once Table Works Properly
- (IBAction)saveNewAthlete:(id)sender {
    //End Editing on any Text Cell that was still active when Save Button was Touched to Commit its changes
    [self.view endEditing:YES];
    
    
    //Implenent some Custom saves from Cells that are custom made for this form;
    VANTextFieldCell *cell = (VANTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    self.athlete.name = cell.textField.text;

    VANNewAthleteProfileCell *pCell = (VANNewAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    self.athlete.number = [NSNumber numberWithInt:[pCell.athleteNumber.text intValue]];
    
    
    //Log All potential Input fields for Debugging Purposes
    NSLog(@"Name: %@", self.athlete.name);
    NSLog(@"Position: %@", self.athlete.position);
    NSLog(@"Email: %@", self.athlete.email);
    NSLog(@"Phone: %@", self.athlete.phoneNumber);
    NSLog(@"Number: %@", self.athlete.number);
    NSLog(@"Birithday: %@", [self.athlete.birthday description]);
    
    if (self.athlete.name == nil || [self.athlete.name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Missing"
                                                        message:@"Please provide a Name"
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self saveManagedObjectContext:self.athlete];
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Create Another Athlete?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Yes"
                                               otherButtonTitles:@"No", nil];
        [action showInView:[self.view.subviews lastObject]];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //AKA Yes, Add new Athlete
        Athlete *athlete = (Athlete *)[self addNewRelationship:@"athletes" toManagedObject:self.event andSave:YES];
        self.athlete = athlete;
        [self.tableView reloadData];
        //[self.view reloadInputViews];
    } else if(buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
    }
}
#pragma mark - Custom Table View Inline Display Methods

-(void)addTextFieldContent:(NSString *)content ToContextForTitle:(NSString *)title {
    if ([title isEqualToString:@"Email"]) {
        self.athlete.email = content;
        NSLog(@"Adding Email");
    } else if ([title isEqualToString:@"Phone Number"]) {
        self.athlete.phoneNumber = content;
        NSLog(@"Add Phone Number");
    } else if ([title isEqualToString:@"Name"]){
        self.athlete.name = content;
        NSLog(@"Add Name");
    } else {
        NSLog(@"Error: Couldn't Save %@", title);
    }
}
/*
-(void)insertInlineDisplayCellAfterIndex:(NSIndexPath *)indexPath forTypeOfCell:(NSString *)cell {
    [self.tableView beginUpdates];
    //Set Up Index's Needed for the Next Code
    NSIndexPath *nextCell = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
    NSIndexPath *previousDelegate = [NSIndexPath indexPathForItem:self.selectedIndex.row-1 inSection:self.selectedIndex.section];
    
    //Changing the Color of the DetailText in the Highlighted Cell
    UITableViewCell *myCell = [self.tableView cellForRowAtIndexPath:indexPath];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    myCell.detailTextLabel.textColor = [teamColor findTeamColor];
    UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:previousDelegate];
    prevCell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    
    if ([cell isEqualToString:kDateType]) {
        if (self.BirthdayCell == YES) {
            [self.tableView deleteRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
            self.BirthdayCell = NO;
            self.selectedIndex = nil;

        } else {

            if (self.PositionCell == YES) {
                [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationMiddle];
                self.PositionCell = NO;
                
            }
            [self.tableView insertRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
            self.BirthdayCell = YES;
            self.selectedIndex = nextCell;
        }
        
    } else if ([cell isEqualToString:kPickerType]) {
        if (self.PositionCell == YES) {
            [self.tableView deleteRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
            self.PositionCell = NO;
            self.selectedIndex = nil;
        } else {
            if (self.BirthdayCell == YES) {
                [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationMiddle];
                self.BirthdayCell = NO;
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                self.selectedIndex = indexPath;
            } else {
                [self.tableView insertRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
                self.selectedIndex = nextCell;

            }
            
            self.PositionCell = YES;
                    }
    }
    [self.tableView endUpdates];
    if (self.PositionCell == YES) {
        [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    
    //Highlight the Color of the Delegate Cell's DetailText

}*/

@end
