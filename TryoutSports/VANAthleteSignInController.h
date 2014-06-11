//
//  VANAthleteSignInControllerViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"
#import "VANCheckInViewController.h"

@interface VANAthleteSignInController : VANManagedObjectViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, VANCheckInDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancelAthleteLookup;

@end
