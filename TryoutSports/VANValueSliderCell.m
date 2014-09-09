//
//  VANValueSliderCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANValueSliderCell.h"
#import "AthleteSkills.h"

@interface VANValueSliderCell ()


@end

@implementation VANValueSliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)sliderValueChanged:(id)sender {
    self.value.text = [NSString stringWithFormat:@"%.01f", self.slider.value];
}

-(void)finisedTouchingSlider:(id)sender {
    self.skill.value = [NSNumber numberWithFloat:self.slider.value];
    [self saveManagedObjectContext:self.skill];
}

@end
