//
//  VANDefaultCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDefaultCell.h"

@implementation VANDefaultCell

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

@end
