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

@interface VANTextFieldCell : VANMotherCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) id value;
@property (strong, nonatomic) VANManagedObjectTableViewController *controller;

-(void)initiate;

@end
