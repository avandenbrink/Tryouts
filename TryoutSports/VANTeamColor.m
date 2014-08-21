//
//  VANTeamColor.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTeamColor.h"




@implementation VANTeamColor

-(instancetype)init {
    
    self.teamColor = [self findTeamColor];
    self.washedColor = [self washedColor];
    return self;
}


-(UIColor *)findTeamColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger number = [defaults integerForKey:kTeamColor];
    switch (number) {
        case 0:
            return [UIColor whiteColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor navyBlue];
            break;
        case 3:
            return [UIColor skyBlue];
            break;
        case 4:
            return [UIColor shamrockGreen];
            break;
        case 5:
            return [UIColor forestGreen];
            break;
        case 6:
            return [UIColor limeGreen];
            break;
        case 7:
            return [UIColor redColor];
            break;
        case 8:
            return [UIColor maroonRed];
            break;
        case 9:
            return [UIColor orangeColor];
            break;
        case 10:
            return [UIColor yellowColor];
            break;
        case 11:
            return [UIColor goldenYellow];
            break;
        case 12:
            return [UIColor purpleColor];
            break;
        case 13:
            return [UIColor pinkColor];
            break;
            
        default:
            return [UIColor blackColor];
            break;
    }

}

-(UIColor *)washedColor {
    UIColor *washed = [self findTeamColor];
    return [washed colorWithAlphaComponent:0.6];
}

-(UIColor *)replaceTeamColor:(UIColor *)color {
    UIColor *currentColor = [self findTeamColor];
    if (currentColor == color) {
        return nil;
    }
    else {
        return color;
    }
}


@end
