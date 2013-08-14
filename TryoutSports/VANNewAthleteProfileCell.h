//
//  VANNewAthleteProfileCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VANNewAthleteProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *athleteHeadshot;
@property (weak, nonatomic) UITextField *athleteName;
@property (weak, nonatomic) IBOutlet UILabel *athleteNumber;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic) double *numberstepper;
 
- (IBAction)numberStepper:(id)sender;
@end
