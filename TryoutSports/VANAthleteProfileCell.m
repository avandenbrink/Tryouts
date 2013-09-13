//
//  VANAthleteProfileCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteProfileCell.h"
#import "VANTeamColor.h"
#import "VANPictureTaker.h"

@interface VANAthleteProfileCell ()

@property (strong, nonatomic) VANPictureTaker *pictureTaker;


@end

@implementation VANAthleteProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.number.text = @"#";
        self.birthday.text = @"Birthday";
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        self.pic.backgroundColor = [teamColor findTeamColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)EditAthleteInformation:(id)sender {
}


@end
