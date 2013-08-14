//
//  VANAddTagCell.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTagsTableViewController.h"

@interface VANAddTagCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentButton;
@property (strong, nonatomic) VANTagsTableViewController *controller;

@end
