//
//  VANEditSkillController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectViewController.h"


@interface VANEditSkillController : VANManagedObjectViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *skillOrTest;
@property (weak, nonatomic) IBOutlet UITableView *quickAccessOptionsTable;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic) BOOL editing;

@end
