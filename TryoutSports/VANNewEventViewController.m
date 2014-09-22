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
@property (strong, nonatomic) UIBarButtonItem *nextButton;

-(NSMutableArray *)getArrayofNumbersUpTo:(NSInteger)number;

@end

@implementation VANNewEventViewController

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    if (self.isNewEvent) {
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
        self.navigationItem.rightBarButtonItem = self.nextButton;
    }
    
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (self.config.rowZero || self.config.rowTwo || self.config.rowThree || self.config.rowFour) {
                return 6;
            } else {
                return 5;
            }
            break;
        case 2:
            return [self.event.teamNames count]+1;
            break;
        case 3:
            return 2;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Event Name" andValue:self.event.name orPlaceholder:@"Required" withKeyboard:UIKeyboardTypeDefault];
    } else if (indexPath.section == 1) {
        if ([indexPath row] == 0) {
            return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Date:" andValue:self.event.startDate];
        } else if ([indexPath row] == 1) {
            if (self.config.rowZero) {
                return [self.config buildDatePickerCellInTable:tableView ForIndex:indexPath forPurpose:@"Date"];
            } else {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Location:" andValue:self.event.location orPlaceholder:@"Optional" withKeyboard:UIKeyboardTypeDefault];
            }
        } else if ([indexPath row] == 2) {
            if (self.config.rowZero) {
                return [self.config buildTextFieldCellInTable:tableView ForIndex:indexPath withLabel:@"Location:" andValue:self.event.location orPlaceholder:@"Optional" withKeyboard:UIKeyboardTypeDefault];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Number of Teams:" andValue:[NSNumber numberWithInteger:([self.event.numTeams integerValue])]];
            }
        } else if ([indexPath row] == 3) {
            if (self.config.rowZero) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Number of Teams:" andValue:[NSNumber numberWithInteger:([self.event.numTeams integerValue])]];
            } else if (self.config.rowTwo) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:10] andSelected:[NSString stringWithFormat:@"%@",self.event.numTeams] forPurpose:@"numTeams"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athlete Age:" andValue:self.event.athleteAge];
            }
        } else if ([indexPath row] == 4) {
            if (self.config.rowZero || self.config.rowTwo) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athlete Age:" andValue:self.event.athleteAge];
            } else if (self.config.rowThree) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:40] andSelected:[NSString stringWithFormat:@"%@",self.event.athleteAge] forPurpose:@"athleteAge"];
            } else {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athletes Per Team" andValue:self.event.athletesPerTeam];
            }
        } else {
            if (self.config.rowZero || self.config.rowTwo || self.config.rowThree) {
                return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Athletes Per Team" andValue:self.event.athletesPerTeam];
            } else {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self getArrayofNumbersUpTo:50] andSelected:[NSString stringWithFormat:@"%@",self.event.athletesPerTeam] forPurpose:@"athletesPerTeam"];
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == [self.event.teamNames count]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
            }
            cell.textLabel.text = @"Add a Team...";
            return cell;
        } else {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
            NSArray *teams = [[self.event.teamNames allObjects] sortedArrayUsingDescriptors:@[sort]];
            TeamName *team = [teams objectAtIndex:indexPath.row];
            return [self.config buildSimpleTextFieldCellInTable:tableView ForIndex:indexPath withLabel:nil andValue:team.name orPlaceholder:nil withKeyboard:UIKeyboardTypeAlphabet];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"Event Information";
            break;
        case 2:
            return @"Teams";
            break;
        case 3:
            return @"More Options";
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANTextFieldCell class]]) {
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    } else {
        if ([indexPath section] == 1) {
            if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[UITableViewCell class]]) {
                 [self.config didSelectRowAtIndex:indexPath inTableView:tableView forTheme:[UIColor blackColor]];
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == [self.event.teamNames count]) {
                [self addNewTeamForIndexPath:indexPath];
            }
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != [self.event.teamNames count]) {
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != [self.event.teamNames count]) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 2 && indexPath.row != [self.event.teamNames count]) {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
            NSArray *teams = [[self.event.teamNames allObjects] sortedArrayUsingDescriptors:@[sort]];
            TeamName *team = [teams objectAtIndex:indexPath.row];
            [self.event removeTeamNamesObject:team];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}
    
#pragma mark- UI Scroll View Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
//    
//    if (self.activeIndex) {
//        VANTextFieldCell *cell = (VANTextFieldCell *)[self.tableView cellForRowAtIndexPath:self.activeIndex];
//        [cell.textField resignFirstResponder];
//        self.activeIndex = nil;
//    }
}

#pragma mark - Custon Methods

-(void)addNewTeamForIndexPath:(NSIndexPath *)indexpath
{
    VANGlobalMethods *global = [[VANGlobalMethods alloc] initwithEvent:self.event];
    TeamName *team = (TeamName *)[global addNewRelationship:@"teamNames" toManagedObject:self.event andSave:NO];
    team.name = [NSString stringWithFormat:@"Team %lu", (unsigned long)[self.event.teamNames count]];
    team.index = [NSNumber numberWithInt:[self.event.teamNames count]];
    team.event = self.event;
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    cell.textLabel.text = team.name;
}

-(void)addTextFieldContent:(NSString *)content forIndexpath:(NSIndexPath *)index {
    switch (index.section) {
        case 0:
            self.event.name = content;
            break;
            
        case 1:
            self.event.location = content;
            break;
        
        case 2:
            if (index.section == 2) {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
                NSArray *teams = [[self.event.teamNames allObjects] sortedArrayUsingDescriptors:@[sort]];
                TeamName *team = [teams objectAtIndex:index.row];
                team.name = content;
            }
            break;
            
        default:
            NSLog(@"Error: Couldn't Save %@. In NEWEvent View's addTextFieldContent ToContext", index);
            break;
    }
}

- (NSMutableArray *)getArrayofNumbersUpTo:(NSInteger)number // Used In CellForRowAtIndex to generate an Array of Numbers up to a Specified Ammount
{
    NSMutableArray *numbers = [NSMutableArray arrayWithObject:@"1"];
    for (NSInteger i = 2; i <= number; i++) {
        [numbers addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return numbers;
}

- (IBAction)saveEvent:(id)sender
{
    [self.view endEditing:YES];
    
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

-(void)next
{
    [self.view endEditing:YES];
    [self.delegate changNameOfDocument:self.document to:self.event.name];
}

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate removeDocument:self.document];
   
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
