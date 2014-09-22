//
//  VANTextFieldCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANMotherCell.h"
#import "VANManagedObjectTableViewController.h"

@class VANTextFieldCell;

@protocol VANTextFieldCellDelegate <NSObject>

-(void)adjustContentInsetsForEditing:(BOOL)editing;
-(void)addTextFieldContent:(NSString *)content forIndexpath:(NSIndexPath *)index;
-(void)textFieldDidClaimFirstResponder:(VANTextFieldCell *)cell;

@end

@interface VANTextFieldCell : VANMotherCell <UITextFieldDelegate>

@property (nonatomic, weak) id <VANTextFieldCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) id value;

-(void)initiate;

@end
