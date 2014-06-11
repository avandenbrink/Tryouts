//
//  VANProfileView.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/4/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANProfileView.h"

@implementation VANProfileView

-(void)setup {
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *dic = @{@"image":self.imageView};

        NSLayoutConstraint *horizondal = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSArray *height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[image]-|" options:0 metrics:0 views:dic];

        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        
        [self addConstraint:horizondal];
        [self addConstraints:height];
        [self.imageView addConstraint:width];
        
        //Setup Image Settings
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 65;
        
    }
    if (!self.button) {
        self.button = [[UIButton alloc] init];
        [self addSubview:self.button];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *dic = @{@"button":self.button};
        NSArray *width = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:0 metrics:0 views:dic];
        NSArray *height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:0 views:dic];
        [self addConstraints:width];
        [self addConstraints:height];

    }
}

-(id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

@end
