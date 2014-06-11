//
//  VANProfileView.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/4/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANAthleteProfileCell.h"

@interface VANProfileView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) VANAthleteProfileCell *delegate;
@property (strong, nonatomic) UIImageView *profileView;

@end
