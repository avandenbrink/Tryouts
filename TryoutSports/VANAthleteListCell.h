//
//  VANAthleteListCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VANAthleteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *athleteHeadshot;
@property (weak, nonatomic) IBOutlet UILabel *aNumber;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *seenImg;
@property (weak, nonatomic) IBOutlet UIImageView *keyedImg;
@property (weak, nonatomic) IBOutlet UIView *numberBG;
@property (weak, nonatomic) IBOutlet UIView *teamBG;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

@end
