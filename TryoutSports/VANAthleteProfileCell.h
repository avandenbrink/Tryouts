//
//  VANAthleteProfileCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANNewAthleteProfileCell.h"

@interface VANAthleteProfileCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UILabel *birthday;

@property (strong, nonatomic) IBOutlet UIImageView *pic;
- (IBAction)EditAthleteInformation:(id)sender;


@end
