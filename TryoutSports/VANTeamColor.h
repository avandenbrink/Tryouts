//
//  VANTeamColor.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+NewColors.h"
#define kTeamColor  @"color"

@interface VANTeamColor : UIColor

@property (strong, nonatomic) UIColor *teamColor;

-(UIColor *)findTeamColor;
-(UIColor *)washedColor;
-(UIColor *)replaceTeamColor:(UIColor *)color;



@end
