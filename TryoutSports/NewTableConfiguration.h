//
//  VANNewEventConfiguration.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANManagedObjectTableViewController.h"
#import "VANTextFieldCell.h"
#import "VANBoolCell.h"
#import "VANDateCell.h"
#import "VANPickerCell.h"
#import "VANDefaultCell.h"

@interface NewTableConfiguration : NSObject

@property (strong, nonatomic) VANManagedObjectTableViewController *controller;
@property (nonatomic) BOOL rowZero;
@property (nonatomic) BOOL rowOne;
@property (nonatomic) BOOL rowTwo;
@property (nonatomic) BOOL rowThree;
@property (nonatomic) BOOL rowFour;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

//New IOS 7 TableViewImplementation Based on max of 5 rows of Selectable Cells

/**
 * Builds and returns a right Detail TableViewCell with given Label and value (into the detailtextlable).
 * @param   label   Text string of the title of the cell
 * @param   value   Value to be displayed in detailTextLabel (Customize this class to expand different types of values from NSString or NSNumber)
 */
-(UITableViewCell *)buildCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value;
/**
 * Builds and returns a VANBoolCell with a Label and a Switch controller
 * @param   label   Text string of the title of the cell
 * @param   value   Bool value to be displayed with the Switch
 */
-(VANBoolCell *)buildBoolCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value;
/**
 * Builds and returns a VANTextFieldCell with a Label and a Text Field
 * @param   label   Text string of the title of the cell
 * @param   value   Value to be displayed in the TextField (Customize this class to expand different types of values from NSString or NSNumber)
 * @param   placeholder   Text string to be used as a placeholder for the TextField
 * @param   keyboard   Type of keyboard that should be revealed when the TextField becomes firstResponder
 */
- (VANTextFieldCell *)buildTextFieldCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withLabel:(NSString *)label andValue:(id)value orPlaceholder:(NSString *)placeholder withKeyboard:(UIKeyboardType)keyboard;
/**
 * Builds and returns a VANDateCell that contains a UIDatePicker with height 216.  Sets the Cell at Index.row - 1 as its Delegate Cell and pushes its returned value to the Delegates detailViewLabel.  (Delegate should be a Right Detail TableViewCell)
 * @param   purpose   A String representation of the keyValue of where this data should be saved. (Spellcheck for accuraccy)
 */
- (VANDateCell *)buildDatePickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index forPurpose:(NSString *)purpose;
/**
 * Builds and returns a VANPickerCell that contains a UIPicker with height 216.  Sets the Cell at Index.row - 1 as its Delegate Cell and pushes its returned value to the Delegates detailViewLabel.  (Delegate should be a Right Detail TableViewCell)
 * @param   values   Array of values to be displayed in the UIPickerView
 * @param   purpose   A String representation of the keyValue of where this data should be saved. (Spellcheck for accuraccy)
 */
- (VANPickerCell *)buildPickerCellInTable:(UITableView *)tableView ForIndex:(NSIndexPath *)index withValues:(NSArray *)values forPurpose:(NSString *)purpose;
/**
 * Adds or Removes Inline Edit cells to the TableView at the indexPath based on which cell was selected. If more than one section is used, this method must be implemented within a conditional syntax for your prefered [indexpath section].
 */
-(void)didSelectRowAtIndex:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
/**
 * Returns the Proper heigh for a Cell and indexPath in the specified TableView. If more than one section is used, this method must be implemented within a conditional syntax for your prefered [indexpath section].
 */
-(CGFloat)setTableViewCellHeightfromTableView:(UITableView *)tableview forIndex:(NSIndexPath *)indexPath;

@end
