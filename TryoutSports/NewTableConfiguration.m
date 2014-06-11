//
//  VANNewEventConfiguration.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "NewTableConfiguration.h"

@interface NewTableConfiguration ()

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) VANTeamColor *teamColor;


@end

@implementation NewTableConfiguration

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

-(id)init {
    self = [super init];
    if (self) {
        self.rowZero = NO;
        self.rowOne = NO;
        self.rowTwo = NO;
        self.rowThree = NO;
        self.rowFour = NO;
        self.teamColor = [[VANTeamColor alloc] init];
    }
    return self;
}

#pragma mark - VAN TextFieldCell Delegate Methods

-(void)adjustContentInsetsForEditing:(BOOL)editing {
    if ([self.delegate respondsToSelector:@selector(adjustContentInsetsForEditing:)]) {
        [self.delegate adjustContentInsetsForEditing:editing];
    } else {
        NSLog(@"Warning: NewTableConfig - Delegate not prepared for adjustContentInsetsForEditing");
    }
    
}

-(void)addTextFieldContent:(NSString *)string ToContextForTitle:(NSString *)title {
    if ([self.delegate respondsToSelector:@selector(addTextFieldContent:ToContextForTitle:)]) {
        [self.delegate addTextFieldContent:string ToContextForTitle:title];
    } else {
        NSLog(@"Warning: NewTableConfig - Delegate not prepared for addTextFieldContent");
    }
}

#pragma mark - Other Custom Methods

//IOS 7 Updates


/** 
 *Builds a RightDetail Table View Cell with given Label and value (into the detailtextlable)
*/
-(UITableViewCell *)buildCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value
{
    static NSString *cellID = @"default";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = label;
    if (value == nil) {
        cell.detailTextLabel.text = @"None Selected";
    } else if ([value isKindOfClass:[NSDate class]]) {
        NSDate *date = value;
        cell.detailTextLabel.text = [__dateFormatter stringFromDate:date];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSString *number = [NSString stringWithFormat:@"%@", value];
        cell.detailTextLabel.text = number;
    } else if ([value isKindOfClass:[NSString class]]) {
        cell.detailTextLabel.text = value;
    } else {
        NSLog(@"Warning: No code setup for Class type of Value");
        cell.detailTextLabel.text = @"Value not determined";
    }
    return cell;
}

-(VANBoolCell *)buildBoolCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andNSNumberBoolValue:(NSNumber *)value orDefault:(BOOL)starter forPurpose:(NSString *)purpose
{
    VANBoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boolCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANBoolCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.purpose = purpose;
    cell.theSwitch.onTintColor = [self.teamColor findTeamColor];
    cell.label.text = label;
    
    if (value) {
        cell.theSwitch.on = [value boolValue];
    } else {
        cell.theSwitch.on = starter;
        [self setBoolValue:starter forPurpose:purpose];
    }
    cell.expandable = NO;
    return cell;
}

- (VANTextFieldCell *)buildTextFieldCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value orPlaceholder:(NSString *)placeholder withKeyboard:(UIKeyboardType)keyboard
{
    VANTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANTextEditCell" owner:self options:nil];
        cell = (VANTextFieldCell *)[cells objectAtIndex:0];
    }
    cell.sideView.backgroundColor = [self.teamColor findTeamColor];
    cell.label.text = label;
    cell.textField.text = value;
    cell.textField.placeholder = placeholder;
    cell.textField.keyboardType = keyboard;
    cell.expandable = NO;
    [cell initiate];
    cell.value = value;
    
    cell.delegate = self;
    return cell;
}

-(VANDateCell *)buildDatePickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index forPurpose:(NSString *)purpose
{
    //General Code for all Uses
    VANDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANDateCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.datePicker.datePickerMode = UIDatePickerModeDate;
    cell.delegateCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row-1 inSection:index.section]];
    cell.expandable = NO;
    //Customize the Date Cell to Specific Purposes =-----=
    
    //if the Cell is being used for Athlete Birthday Picker -
    if ([purpose isEqualToString:@"Birthday"]) {
        cell.datePicker.maximumDate = [NSDate date];
        if (self.athlete.birthday == NULL) {
            NSInteger integ = [self.event.athleteAge intValue]*365*24*60*60;
            cell.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:-integ];
        } else {
            cell.datePicker.date = self.athlete.birthday;
        }
        cell.athlete = self.athlete;
        
    } else if ([purpose isEqualToString:@"Event Date"]) {
        cell.datePicker.minimumDate = [NSDate date];
        cell.event = self.event;
        if (self.event.startDate == NULL) {
            cell.datePicker.date = [NSDate date];
        } else {
            cell.datePicker.date = self.event.startDate;
        }
    }
    return cell;
}

-(VANPickerCell *)buildPickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withValues:(NSArray *)values andSelected:(NSString *)selected forPurpose:(NSString *)purpose
{
    VANPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANPickerCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    cell.delegate = self;
    cell.pickerView.delegate = cell;
    cell.pickerView.dataSource = cell;
    cell.expandable = NO;
    
    NSIndexPath *cellDelegateCell = [NSIndexPath indexPathForRow:index.row-1 inSection:index.section];
    cell.delegateCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:cellDelegateCell];
    
    if (self.athlete) {
        cell.athlete = self.athlete;
    }
    if (self.event) {
        cell.event = self.event;
    }
    
    cell.values = values;
    cell.purpose = purpose;
    
    if ([values count] > 0 || !values) {
        if ([_delegate respondsToSelector:@selector(createAlertViewforEmptyPickerViewCellWithPurpose:)]) {
            UIAlertView *alert = [_delegate createAlertViewforEmptyPickerViewCellWithPurpose:purpose];
            [alert show];
        }
    }
    
    BOOL isFound = NO;
    for (int i = 0; i < [values count]; i++) {
        NSString *v = [values objectAtIndex:i];
        if ([v isEqualToString:selected]) {
            [cell.pickerView selectRow:i inComponent:0 animated:NO];
            isFound = YES;
        }
    }
    if (!isFound) {
        [cell.pickerView selectRow:0 inComponent:0 animated:YES];
    }
    
    return cell;
}

-(NSInteger)findAthletePosition:(NSString*)position inArray:(NSArray*)array
{
    for (NSInteger i = 0; i < [array count]; i++) {
        Positions *p = [array objectAtIndex:i];
        if ([p.position isEqualToString:position]) {
            return i;
        }
    }
    NSLog(@"No Position Found");
    return 0;
}


-(void)didSelectRowAtIndex:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView forTheme:(UIColor *)color
{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANPickerCell class]] ) {
        NSLog(@"Error: Selected a Picker Cell instead of a Label cell");
    } else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Changing the Color of the DetailText in the Highlighted Cell
    VANDefaultCell *myCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:indexPath];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    myCell.detailTextLabel.textColor = [teamColor findTeamColor];
    VANDefaultCell *prevCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:self.selectedIndex];
    prevCell.detailTextLabel.textColor = color;
    
    //Set Up Index's Needed for the Next Code
    NSIndexPath *oldNextCell = [NSIndexPath indexPathForItem:self.selectedIndex.row+1 inSection:self.selectedIndex.section];
    NSIndexPath *nextCell = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];

    //Determining where the Selected Cell is located in Relation to the previously selected cell to decide which action to take
    if (!self.selectedIndex) {
        //If No previously selected Cell exists
        self.selectedIndex = indexPath;
        [self setBoolForIndexPath:indexPath];
        [tableView insertRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
    } else if (indexPath.row == self.selectedIndex.row) {
        //If Previously selected Cell is the cell that we just selected
        self.selectedIndex = nil;
        self.rowZero = NO; //Deal with the Various Bool Objects
        self.rowOne = NO;
        self.rowThree = NO;
        self.rowFour = NO;
        self.rowTwo = NO;
        [tableView deleteRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
    } else if (indexPath.row < self.selectedIndex.row) {
        //If Selected Cell is Lower than the Previously selected
        [tableView beginUpdates];
        [self setBoolForIndexPath:indexPath];
        self.selectedIndex = indexPath;
        [tableView deleteRowsAtIndexPaths:@[oldNextCell] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView insertRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
    } else if (indexPath.row > self.selectedIndex.row) {
        //If Selected Cell is higher on table Index then Previously Selected Cell
        [self setAllBoolstoNil];
        [tableView deleteRowsAtIndexPaths:@[oldNextCell] withRowAnimation:UITableViewRowAnimationMiddle];
        [self setBoolForIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        self.selectedIndex = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    
    //Animating the Scroll View for each selectable Row to ensure the entire Picker is visible in the screen
    if (self.rowTwo) {
        //[tableView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (self.rowThree) {
        //[tableView setContentOffset:CGPointMake(0, 150) animated:YES];
    } else if (self.rowFour) {
        [tableView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
    }
}

-(void)setBoolForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.rowZero = YES;
        self.rowOne = NO;
        self.rowThree = NO;
        self.rowFour = NO;
        self.rowTwo = NO;
    } else if (indexPath.row == 1) {
        if (self.rowZero) {
    
        } else {
            self.rowZero = NO;
            self.rowOne = YES;
            self.rowThree = NO;
            self.rowFour = NO;
            self.rowTwo = NO;
        }
    } else if (indexPath.row == 2) {
        if (self.rowZero) {
            self.rowZero = NO;
            self.rowOne = YES;
        } else {
            self.rowZero = NO;
            self.rowThree = NO;
            self.rowFour = NO;
            self.rowOne = NO;
            self.rowTwo = YES;
        }
    } else if (indexPath.row == 3) {
        if (self.rowZero || self.rowOne) {
            self.rowZero = NO;
            self.rowOne = NO;
            self.rowTwo = YES;
        } else {
            self.rowZero = NO;
            self.rowOne = NO;
            self.rowTwo = NO;
            self.rowThree = YES;
            self.rowFour = NO;
        }
    } else if (indexPath.row == 4) {
        if (self.rowZero || self.rowOne || self.rowTwo) {
            self.rowZero = NO;
            self.rowOne = NO;
            self.rowTwo = NO;
            self.rowThree = YES;
        } else {
            self.rowZero = NO;
            self.rowOne = NO;
            self.rowTwo = NO;
            self.rowThree = NO;
            self.rowFour = YES;
        }
    } else if (indexPath.row == 5){
        if (self.rowZero || self.rowOne || self.rowTwo || self.rowThree) {
            self.rowZero = NO;
            self.rowOne = NO;
            self.rowTwo = NO;
            self.rowThree = NO;
            self.rowFour = YES;
        }
    } else {
        NSLog(@"Need To Look at setBoolForIndexPath method: NewTableConfigureatoin");
    }
}



- (void)setAllBoolstoNil
{
    self.rowZero = NO;
    self.rowOne = NO;
    self.rowTwo = NO;
    self.rowThree = NO;
    self.rowFour = NO;
}



-(CGFloat)setTableViewCellHeightfromTableView:(UITableView *)tableview forIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && self.rowZero) {
        return 216;
    } else if (indexPath.row == 2 && self.rowOne) {
        return 216;
    } else if (indexPath.row == 3 && self.rowTwo) {
        return 216;
    } else if (indexPath.row == 4 && self.rowThree) {
        return 216;
    } else if (indexPath.row == 5 && self.rowFour) {
        return 216;
    } else {
        return 50;
    }
}

#pragma mark - VAN Bool Cell Delegate Methods

-(void)setBoolValue:(BOOL)value forPurpose:(NSString *)purpose
{
    if ([_delegate respondsToSelector:@selector(setBoolianValue:forPurpose:)]) {
        [_delegate setBoolianValue:value forPurpose:purpose];
    }
}

#pragma mark - VAN Picker Cell Delegate Methods

-(void)VANPickerCell:(VANPickerCell *)cell didChangeToRow:(NSInteger)row withValues:(NSArray *)values
{
    if ([_delegate respondsToSelector:@selector(pickerCell:didChangeValueToRow:inArray:)]) {
        [_delegate pickerCell:cell didChangeValueToRow:row inArray:values];
    }
}

@end
