//
//  VANFilterButtonCell.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-13.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANFilterButtonCell.h"

@implementation VANFilterButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.segmentControl = [[UISegmentedControl alloc] init];
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.segmentControl insertSegmentWithTitle:@"All" atIndex:0 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"Good" atIndex:1 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"Neutral" atIndex:2 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"Bad" atIndex:3 animated:NO];
        [self.contentView addSubview:self.segmentControl];
        NSDictionary *dic = @{@"seg": self.segmentControl};
        NSArray *hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[seg]-(10)-|" options:0 metrics:0 views:dic];
        NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[seg]-(10)-|" options:0 metrics:0 views:dic];
        [self.contentView addConstraints:hor];
        [self.contentView addConstraints:vert];
        self.segmentControl.selectedSegmentIndex = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
