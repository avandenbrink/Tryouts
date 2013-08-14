//
//  VANValueSliderCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANMotherCell.h"

@interface VANValueSliderCell : VANMotherCell

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UIImageView *sideColor;
@property (strong, nonatomic) AthleteSkills *skill;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)finisedTouchingSlider:(id)sender;
@end
