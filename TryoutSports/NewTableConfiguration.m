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

//IOS 7 Updates


/** 
 *Builds a RightDetail Table View Cell with given Label and value (into the detailtextlable)
*/
-(UITableViewCell *)buildCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value {
    VANDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightDetailCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.sideView.backgroundColor = [self.teamColor findTeamColor];
    cell.label.text = label;
    if (value == nil) {
        cell.detailLabel.text = @"None Selected";
    } else if ([value isKindOfClass:[NSDate class]]) {
        NSDate *date = value;
        cell.detailLabel.text = [__dateFormatter stringFromDate:date];
        NSLog(@"%@", [value description]);
    } else if ([value isKindOfClass:[NSNumber class]]){
        cell.detailLabel.text = [NSString stringWithFormat:@"%@", value];
    } else {
        cell.detailLabel.text = value;
    }
    return cell;
}

-(VANBoolCell *)buildBoolCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value {
    VANBoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boolCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANBoolCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sideView.backgroundColor = [self.teamColor findTeamColor];
    cell.theSwitch.onTintColor = [self.teamColor findTeamColor];
    cell.label.text = label;
    if (value == [NSNumber numberWithInt:1]) {
        cell.theSwitch.on = YES;
    } else {
        cell.theSwitch.on = NO;
    }
    cell.expandable = NO;
    return cell;
}

- (VANTextFieldCell *)buildTextFieldCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value orPlaceholder:(NSString *)placeholder withKeyboard:(UIKeyboardType)keyboard {
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
    cell.controller = self.controller;
    return cell;
}

-(VANDateCell *)buildDatePickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index forPurpose:(NSString *)purpose {
    //General Code for all Uses
    VANDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANDateCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.datePicker.datePickerMode = UIDatePickerModeDate;
    cell.sideView.backgroundColor = [self.teamColor findTeamColor];
    cell.delegateCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row-1 inSection:index.section]];
    cell.expandable = NO;
    NSLog(@"%@", cell.delegateCell.detailLabel.text);
    //Customize the Date Cell to Specific Purposes =-----=
    
    //if the Cell is being used for Athlete Birthday Picker -
    if ([purpose isEqualToString:@"Birthday"]) {
        cell.datePicker.maximumDate = [NSDate date];
        if (self.controller.athlete.birthday == NULL) {
            NSInteger integ = [self.controller.event.athleteAge intValue]*365*24*60*60;
            cell.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:-integ];
        } else {
            cell.datePicker.date = self.controller.athlete.birthday;
        }
        cell.athlete = self.controller.athlete;
    } else if ([purpose isEqualToString:@"Event Date"]) {
        cell.datePicker.minimumDate = [NSDate date];
        cell.event = self.controller.event;
        if (self.controller.event.startDate == NULL) {
            cell.datePicker.date = [NSDate date];
        } else {
            cell.datePicker.date = self.controller.event.startDate;
        }
        
    }
    
        
    return cell;
}

-(VANPickerCell *)buildPickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withValues:(NSArray *)values forPurpose:(NSString *)purpose {
    VANPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerCell"];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANPickerCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.pickerView.delegate = cell;
    cell.pickerView.dataSource = cell;
    cell.sideView.backgroundColor = [self.teamColor findTeamColor];
    cell.delegateCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row-1 inSection:index.section]];
    cell.expandable = NO;
    NSMutableArray *array = [NSMutableArray arrayWithArray:values];
    if ([purpose isEqualToString:@"Position"]) {
        if ([values count] >= 1) {
            NSLog(@"Values are being registered");
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
            cell.values = [array sortedArrayUsingDescriptors:@[descriptor]];
            cell.athlete = self.controller.athlete;
        } else {
            NSLog(@"there are no Values");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something Missing?" message:@"Customize Positions in Event Settings" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Go Now", nil];
            [alert show];
        }
    } else {
        cell.values = [array sortedArrayUsingSelector:@selector(compare:)];
        cell.event = self.controller.event;
        cell.purpose = purpose;
        if ([cell.event valueForKey:purpose] != nil) {
            [cell.pickerView selectRow:[values indexOfObject:[self.controller.event valueForKey:purpose]] inComponent:0 animated:NO];
        } else {
           [cell.pickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
    return cell;
}

-(void)didSelectRowAtIndex:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[VANPickerCell class]] ) {
        NSLog(@"Error: Selected a Picker Cell instead of a LAbel cell");
    } else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Changing the Color of the DetailText in the Highlighted Cell
    VANDefaultCell *myCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:indexPath];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    myCell.detailLabel.textColor = [teamColor findTeamColor];
    VANDefaultCell *prevCell = (VANDefaultCell *)[tableView cellForRowAtIndexPath:self.selectedIndex];
    prevCell.detailLabel.textColor = [UIColor darkGrayColor];
    
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
        [tableView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (self.rowThree) {
        [tableView setContentOffset:CGPointMake(0, 150) animated:YES];
    } else if (self.rowFour) {
        [tableView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
    }
}

-(void)setBoolForIndexPath:(NSIndexPath *)indexPath {
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
        NSLog(@"Need To Look at setBoolForIndexPath method");
    }
}
         
- (void)setAllBoolstoNil {
    self.rowZero = NO;
    self.rowOne = NO;
    self.rowTwo = NO;
    self.rowThree = NO;
    self.rowFour = NO;
}

-(CGFloat)setTableViewCellHeightfromTableView:(UITableView *)tableview forIndex:(NSIndexPath *)indexPath {
    
    
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


@end
