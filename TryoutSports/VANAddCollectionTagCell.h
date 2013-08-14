//
//  VANAddCollectionTagCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTagsViewController.h"

@interface VANAddCollectionTagCell : UICollectionViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) VANTagsViewController *controller;
- (IBAction)saveNewTag:(id)sender;

@end
