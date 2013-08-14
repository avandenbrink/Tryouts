//
//  VANNewAthleteProfileCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewAthleteProfileCell.h"

@implementation VANNewAthleteProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.stepper.maximumValue = 200;
        self.athleteName.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.athleteName.enabled = YES;
        //[self.stepper addTarget:self action:@selector(numberstepper) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {

    }
return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)numberStepper:(id)sender {
    self.athleteNumber.text = [NSString stringWithFormat:@"%1.f", self.stepper.value];
}


@end
