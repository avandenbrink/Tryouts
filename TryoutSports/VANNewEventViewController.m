//
//  VANNewEventViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewEventViewController.h"
#import "Event.h"

@interface VANNewEventViewController ()

@property (strong, nonatomic) NewTableConfiguration *config;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;

-(NSMutableArray *)getArrayofNumbersUpTo:(NSInteger)number;

@end

@implementation VANNewEventViewController

@synthesize fetchedResultsController = _fetchedResultsController;

//Migrating to CoreData from Plist date storage Keep this as referrence for possible future use
/*
 - (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"events.plist"];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    self.config = [[NewTableConfiguration alloc] init];
    self.config.delegate = self;
    self.config.event = self.event;
    
    self.navigationItem.hidesBackButton = YES;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.event.numTeams = [NSNumber numberWithInteger:[self.event.numTeams integerValue] -1];;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (self.config.rowZero || self.config.rowTwo || self.config.rowThree || self.config.rowFour) {
            return 6;
        } else {
            return 5;
        }
    } else {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        //Only 1 Option for Row 0
        return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Name" andValue:self.event.name orPlaceholder:@"Required" withKeyboard:UIKeyboardTypeDefault];
    } else if ([indexPath section] == 1) {
        
        if ([indexPath row] == 0) {
            //Row 0
            //Only 1 Option for Row 0
            return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Event Date:" andValue:self.event.startDate];

        } else if ([indexPath row] == 1) {
            //Row 1
            //If Row 0 is Activated this will be its Cell otherwise it will be Regualar Row 1
            if (self.config.rowZero) {
                return [self.config buildDatePickerCellInTable:tableView ForIndex:indexPath forPurpose:@"Event Date"];
            } else {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Location:" andValue:self.event.location orPlaceholder:@"Optional" withKeyboard:UIKeyboardTypeDefault];
            }
        } else if ([indexPath row] == 2) {
            //Row 2
            //If Row 0 is activated this will be Regular Row 1 Else will be Row 2
            if (self.config.rowZero) {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Location:" andValue:self.event.location orPlaceholder:@"Optional" withKeyboard:UIKeyboardTypeDefault];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Number of Teams:" andValue:[NSNumber numberWithInteger:([self.event.numTeams integerValue])]];
            }
        } else if ([indexPath row] == 3) {
            //Row 3
            //If Row 0 is actiavted with will be regular Row 2 Unless regular row 2 is activated This row will be its Options Cell, If neither are activated, It belonges to regular Row 3
            if (self.config.rowZero) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Number of Teams:" andValue:[NSNumber numberWithInteger:([self.event.numTeams integerValue])]];
            } else if (self.config.rowTwo) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:10] andSelected:[NSString stringWithFormat:@"%@",self.event.numTeams] forPurpose:@"numTeams"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athlete Age:" andValue:self.event.athleteAge];
            }
        } else if ([indexPath row] == 4) {
            //Row 4
            //If Row 0 or Row 2 are active, this becomes row 3, If row 3 is active then this becomes its Optoins Cell, otherwise it is regular row 4
            
            if (self.config.rowZero || self.config.rowTwo) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athlete Age:" andValue:self.event.athleteAge];
            } else if (self.config.rowThree) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:40] andSelected:[NSString stringWithFormat:@"%@",self.event.athleteAge] forPurpose:@"athleteAge"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athletes Per Team" andValue:self.event.athletesPerTeam];
            }
        
        } else {
            //Row 5
            //If Row 0, 2, or 3 are active, this becomes row 4, unless row 4 is active then this is its Options Cell, otherwise it is empty with no Selections
            if (self.config.rowZero || self.config.rowTwo || self.config.rowThree) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athletes Per Team" andValue:self.event.athletesPerTeam];
            } else {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:50] andSelected:[NSString stringWithFormat:@"%@",self.event.athletesPerTeam] forPurpose:@"athletesPerTeam"];
            }
        }
    } else {
        if ([indexPath row] == 0) {
            return [self.config buildBoolCellInTable:tableView ForIndex:indexPath withLabel:@"Athlete Sign-In:" andNSNumberBoolValue:self.event.athleteSignIn orDefault:YES forPurpose:@"signIn"];
        } else {
            return [self.config buildBoolCellInTable:tableView ForIndex:indexPath withLabel:@"Manage Personal Info:" andNSNumberBoolValue:self.event.manageInfo orDefault:YES forPurpose:@"info"];
        }
    }
}

#pragma mark - TableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return 50;
    } if ([indexPath section] == 1) {
        return [self.config setTableViewCellHeightfromTableView:tableView forIndex:indexPath];
    } else {
        return 50;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Event Information";
    } else if (section == 2){
        return @"More Options";
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANTextFieldCell class]]) {
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    } else if ([indexPath section] == 1) {
        if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[UITableViewCell class]]) {
                 [self.config didSelectRowAtIndex:indexPath inTableView:tableView forTheme:[UIColor blackColor]];
            
        }
    }
}

#pragma mark - Custon Methods

-(void)addTextFieldContent:(NSString *)content ToContextForTitle:(NSString *)title {
    if ([title isEqualToString:@"Name"]) {
        self.event.name = content;
        NSLog(@"Adding Name");
    } else if ([title isEqualToString:@"Location:"]) {
        self.event.location = content;
        NSLog(@"Add Location");
    } else {
        NSLog(@"Error: Couldn't Save %@", title);
    }
}

//Used In CellForRowAtIndex to generate an Array of Numbers up to a Specified Ammount
-(NSMutableArray *)getArrayofNumbersUpTo:(NSInteger)number {
    NSMutableArray *numbers = [NSMutableArray arrayWithObject:@"1"];
    for (NSInteger i = 2; i <= number; i++) {
        [numbers addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return numbers;
}

//When "Next" is tapped, this method is called
- (IBAction)saveEvent:(id)sender {
    [self.view endEditing:YES];
    
    //Log the Event qualities for debugging Purposes
    NSLog(@"Name: %@", self.event.name);
    NSLog(@"Date: %@", [self.event.startDate description]);
    NSLog(@"Location: %@", self.event.location);
    NSLog(@"Number of Teams: %@", self.event.numTeams);
    NSLog(@"Athlete Age: %@", self.event.athleteAge);
    NSLog(@"Athletes Per Team: %@", self.event.athletesPerTeam);
    
    self.event.numTeams = [NSNumber numberWithInt:[self.event.numTeams intValue] + 1];
    
    //Checks to ensure that the Name quality is not Empty
    if (self.event.name == nil || [self.event.name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Missing" message:@"Your Event must have a name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self saveManagedObjectContext:self.event];
        [self performSegueWithIdentifier:@"toNext" sender:self.event];
    }
}

#pragma mark - NewTableConfiguration Delegate Methods

-(void)pickerCell:(VANPickerCell *)cell didChangeValueToRow:(NSInteger)row inArray:(NSArray *)array
{
    NSString *n = [array objectAtIndex:row];
    if ([cell.purpose isEqualToString:@"numTeams"]) {
        self.event.numTeams = [NSNumber numberWithInteger:[n integerValue]];
    } else if ([cell.purpose isEqualToString:@"athleteAge"]) {
        self.event.athleteAge = [NSNumber numberWithInteger:[n integerValue]];
    } else if ([cell.purpose isEqualToString:@"athletesPerTeam"]) {
        self.event.athletesPerTeam = [NSNumber numberWithInteger:[n integerValue]];
    }
}

-(void)setBoolianValue:(BOOL)value forPurpose:(NSString *)purpose {
    if ([purpose isEqualToString:@"signIn"]) {
        self.event.athleteSignIn = [NSNumber numberWithBool:value];
    } else if ([purpose isEqualToString:@"info"]){
        self.event.manageInfo = [NSNumber numberWithBool:value];
    }
}

#pragma mark - Segue Methods

//Prepares Segue to Next ViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"toNext"]) {
      if ([sender isKindOfClass:[NSManagedObject class]]) {
          NSLog(@"Building new View Controller and adding New event");
          VANNewSkillsAndTestsController *newEventController = segue.destinationViewController;
          newEventController.event = sender;
      } else {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hero Detail Error", @"Hero Detail Error") message:NSLocalizedString(@"Error Showing Detail",@"Error Showing Detail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
          [alert show];
      }
  }
}

@end
