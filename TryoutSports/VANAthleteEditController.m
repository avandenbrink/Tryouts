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

//Cell Identifiers
static NSString *cAthleteProfile = @"VANNewAthleteProfileCell";


@interface VANAthleteEditController ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) NewTableConfiguration *config;
@property (strong, nonatomic) VANPictureTaker *pictureTaker;

@property (strong, nonatomic) NSString *tempName;
@property (strong, nonatomic) NSString *tempEmail;
@property (strong, nonatomic) NSNumber *tempAge;
@property (strong, nonatomic) NSDate *tempBirthday;
@property (strong, nonatomic) NSNumber *tempNumber;
@property (strong, nonatomic) NSString *tempPhoneNumber;
@property (strong, nonatomic) NSString *tempPosition;

@end

@implementation VANAthleteEditController

-(void)setAthlete:(Athlete *)athlete
{
    [super setAthlete:athlete];
    self.tempName = athlete.name;
    self.tempEmail = athlete.email;
    self.tempAge = athlete.age;
    self.tempBirthday = athlete.birthday;
    self.tempNumber = athlete.number;
    self.tempPhoneNumber = athlete.phoneNumber;
    self.tempPosition = athlete.position;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.config = [[NewTableConfiguration alloc] init];
    self.config.delegate = self;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    NSMutableArray *rightButtons = [NSMutableArray array];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAthleteAndClose)];
    [rightButtons addObject:save];
    
    if (self.isNew) {
        self.tempNumber = [NSNumber numberWithInteger:[self.event.athletes count]];
        UIBarButtonItem *saveAndMore = [[UIBarButtonItem alloc] initWithTitle:@"Add Another" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndCreateAnotherAthlete)];
        [rightButtons addObject:saveAndMore];
    }
    
    self.navigationItem.rightBarButtonItems = rightButtons;

}

- (IBAction)launchCamera:(id)sender
{
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
    }
    self.pictureTaker.delegate = self;
    [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isNew) {
        return 3;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1; // Name Value
    } else if (section == 1){
        return 1; // Image and Number
    } else if (section == 3) {
        return 1; // Delete Button
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
        return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Name" andValue:self.tempName orPlaceholder:@"Required" withKeyboard:UIKeyboardTypeAlphabet];
        
    } else if ([indexPath section] == 1) {
        //Create Image and Number Cell
        cellIdentifier = cAthleteProfile;
        VANNewAthleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        //Setup Image Headshot Rules:
        cell.athleteHeadshot.layer.masksToBounds = YES;
        cell.athleteHeadshot.layer.cornerRadius = cell.athleteHeadshot.frame.size.height/2;
        cell.athleteHeadshot.backgroundColor = [UIColor darkGrayColor];
        
        if (self.athlete.profileImage) {
            Image *img = self.athlete.profileImage;
            NSData *imgData = img.headShot;
            cell.athleteHeadshot.image = [UIImage imageWithData:imgData];
        } else {
            cell.athleteHeadshot.image = [UIImage imageNamed:@"cameraButton.png"];
        }
        
        //Set up Number Stepper
        cell.stepper.maximumValue = 200;
        
        cell.stepper.value = [self.tempNumber integerValue];
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
            return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Birthday" andValue:self.tempBirthday];
        } else if ([indexPath row] == 1) {
            //Position Cell
            if (self.config.rowZero) {
                return [self.config buildDatePickerCellInTable:tableView ForIndex:indexPath forPurpose:@"Birthday"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Position" andValue:self.tempPosition];
            }
        } else if ([indexPath row] == 2 ) {
            if (self.config.rowZero) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Position" andValue:self.tempPosition];
            } else if (self.config.rowOne) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self.event.positions allObjects] andSelected:self.tempPosition forPurpose:@"Position"];
            } else {
            
            return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Email" andValue:self.tempEmail orPlaceholder:@"Email"withKeyboard:UIKeyboardTypeEmailAddress];
        
            }
        } else if ([indexPath row] == 3){
            if ([tableView numberOfRowsInSection:2] == 5) {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Email" andValue:self.tempEmail orPlaceholder:@"Email" withKeyboard:UIKeyboardTypeEmailAddress];
            } else {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Phone Number" andValue:self.tempPhoneNumber orPlaceholder:@"Number" withKeyboard:UIKeyboardTypeNumbersAndPunctuation];
            }
            
        } else {
            return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Phone Number" andValue:self.tempPhoneNumber orPlaceholder:@"Number" withKeyboard:UIKeyboardTypeNumbersAndPunctuation];
        }
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
    } if (indexPath.section == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Athlete?"
                                                        message:@"Are you Sure you want to Delete this athlete?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - Completion Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"saveToAthleteList"]) {

    }
}

- (void)saveAthleteAndClose
{
    [self.view endEditing:YES];
    
    if (!self.athlete) {
        VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
        self.athlete = (Athlete *)[methods addNewRelationship:athleteRelationship toManagedObject:self.event andSave:NO];
        self.athlete.seen = [NSNumber numberWithBool:NO];
        self.athlete.flagged = [NSNumber numberWithBool:NO];
    }
    
    self.athlete.name = self.tempName;
    self.athlete.number = self.tempNumber;
    self.athlete.email = self.tempEmail;
    self.athlete.phoneNumber = self.tempPhoneNumber;
    self.athlete.age = self.tempAge;
    self.athlete.position = self.tempPosition;
    self.athlete.birthday = self.tempBirthday;
    
    /* To Delete */
    VANTextFieldCell *cell = (VANTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    self.athlete.name = cell.textField.text;
    VANNewAthleteProfileCell *pCell = (VANNewAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    self.athlete.number = [NSNumber numberWithInt:[pCell.athleteNumber.text intValue]];

    if (self.athlete.name == nil || [self.athlete.name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Required"
                                                        message:@"Cannot save an athlete without a name."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        [self saveManagedObjectContext:self.athlete];
        if ([_delegate respondsToSelector:@selector(closeAthleteEditPopover)]) {
            [_delegate closeAthleteEditPopover];
        } else {
            if ([self.navigationController.viewControllers count] == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)cancel
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

-(void)saveAndCreateAnotherAthlete
{
    
}

#pragma mark - UI Alert View Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSManagedObjectContext *context = self.athlete.managedObjectContext;
        [context deleteObject:self.athlete];
//        UIViewController *toController;
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[VANAthleteListViewController class]]) {
//                toController = controller;
//            }
//        }
//        [self.navigationController popToViewController:toController animated:YES];
    } else {
        
    }
}

#pragma mark - UI Action Sheet Methods

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
        self.tempEmail = content;
        NSLog(@"Adding Email");
    } else if ([title isEqualToString:@"Phone Number"]) {
        self.tempPhoneNumber = content;
        NSLog(@"Add Phone Number");
    } else if ([title isEqualToString:@"Name"]){
        self.tempName = content;
        NSLog(@"Add Name");
    } else {
        NSLog(@"Error: Couldn't Save %@", title);
    }
}

@end
