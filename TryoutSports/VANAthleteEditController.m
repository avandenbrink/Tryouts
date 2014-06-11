//
//  VANNewAthleteController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteEditController.h"
#import "VANNewAthleteProfileCell.h"
#import "VANMotherCell.h"
#import "VANTextFieldCell.h"
#import "VANTeamColor.h"
#import "VANPickerCell.h"
#import "VANPictureTaker.h"
#import "VANAthleteDetailController.h"
#import "Image.h"


static NSString *kDateType = @"Date";
static NSString *kPickerType = @"Picker";

@interface VANAthleteEditController ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) NewTableConfiguration *config;
@property (strong, nonatomic) VANPictureTaker *pictureTaker;

@end

@implementation VANAthleteEditController

/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.config = [[NewTableConfiguration alloc] init];
    self.config.delegate = self;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}
     

-(void)cancel {
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];
    if ([controller isKindOfClass:[VANAthleteListViewController class]]) {
        NSManagedObjectContext *context = [self.athlete managedObjectContext];
        [context deleteObject:self.athlete];
        if (self.delegate) {
            [self dismissViewControllerAnimated:YES completion:nil ];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)launchCamera:(id)sender {
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
    }
    self.pictureTaker.delegate = self;
    [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];
    
    if ([controller isKindOfClass:[VANAthleteListViewController class]]) {
        return 3;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (!self.config.rowZero && !self.config.rowOne) {
        return 4;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    if ([indexPath section] == 0) {
        return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Name" andValue:self.athlete.name orPlaceholder:@"Required" withKeyboard:UIKeyboardTypeAlphabet];

    } else if ([indexPath section] == 1) {
        //Create Image and Number Cell
        cellIdentifier = @"VANNewAthleteProfileCell";
        VANNewAthleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        
        //Set up Image Headshot Rules:
        cell.athleteHeadshot.layer.masksToBounds = YES;
        cell.athleteHeadshot.layer.cornerRadius = cell.athleteHeadshot.frame.size.height/2;
        cell.athleteHeadshot.backgroundColor = [UIColor darkGrayColor];
        NSArray *array = [self.athlete.images allObjects];
        if ([array count] > 0) { //Check to see if we already have headshots of this athlete? aka editing their info
            Image *img = [array objectAtIndex:0];
            NSData *imgData = img.headShot;
            cell.athleteHeadshot.image = [UIImage imageWithData:imgData];
        } else {
            cell.athleteHeadshot.image = [UIImage imageNamed:@"cameraButton.png"];
        }
        
        //Set up Number Stepper
        cell.stepper.maximumValue = 200;
        //If this is a new Athlete, we need to give them a default number to start
        
        cell.stepper.value = [self.athlete.number integerValue];
        VANTeamColor *color = [[VANTeamColor alloc] init];
        if ([color findTeamColor] == [UIColor whiteColor]) {
            cell.stepper.tintColor = [UIColor blackColor];
        }
        cell.athleteNumber.text = [NSString stringWithFormat:@"%1.f", [cell.stepper value]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if ([indexPath section] == 3) {
        cellIdentifier = @"DeleteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"Delete Athlete";
        
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
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self.event.positions allObjects] andSelected:self.athlete.position forPurpose:@"Position"];
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
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == 1) {
        return 211;
    } else {
        return [self.config setTableViewCellHeightfromTableView:tableView forIndex:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANTextFieldCell class]]) {
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        
    } else if ([indexPath section] == 2) {
            [self.config didSelectRowAtIndex:indexPath inTableView:tableView forTheme:[UIColor blackColor]];
            /*
            if ([indexPath row] == 0) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kDateType];
            } else if ([indexPath row] == 1 && !self.config.rowZero) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kPickerType];
            } else if ([indexPath row] == 2 && self.BirthdayCell == YES) {
                [self insertInlineDisplayCellAfterIndex:indexPath forTypeOfCell:kPickerType];
            }*/
    } if (indexPath.section == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Athlete?" message:@"Are you Sure you want to Delete this athlete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UI Alert View Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSManagedObjectContext *context = self.athlete.managedObjectContext;
        [context deleteObject:self.athlete];
        UIViewController *toController;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[VANAthleteListViewController class]]) {
                toController = controller;
            }
        }
        [self.navigationController popToViewController:toController animated:YES];
    } else {
        
    }
}

#pragma mark - VANImagePicker Delegate Methods

-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passBackSelectedImageData:(NSData *)imageData {
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Image *image = (Image *)[methods addNewRelationship:@"headShotImage" toManagedObject:self.athlete andSave:YES];
    image.headShot = imageData;
    
    VANNewAthleteProfileCell *cell = (VANNewAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.athleteHeadshot.image = [UIImage imageWithData:imageData];
    
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
    if (!self.athlete.seen) {
        self.athlete.seen = [NSNumber numberWithBool:NO];
    }
    if (!self.athlete.flagged) {
        self.athlete.flagged = [NSNumber numberWithBool:NO];
    }
    
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
        if (self.delegate) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
