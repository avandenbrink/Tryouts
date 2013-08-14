//
//  VANIntroShape.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-12.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface VANIntroShape : UIView


@property (nonatomic) CGFloat firstPoint;
@property (nonatomic) CGFloat secondPoint;
@property (nonatomic) CGFloat thirdPoint;

@property (nonatomic, retain) UILabel *statTitle;
@property (nonatomic, retain) UILabel *teamLabel;
@property (nonatomic, retain) UILabel *seenLabel;

@property (nonatomic, retain) UIView *barView;
@property (nonatomic, retain) UIView *teamView;
@property (nonatomic, retain) UIView *seenView;

@property (nonatomic) UIButton *teamButton;
@property (nonatomic) UIButton *seenButton;

-(void)findPercentAndAnimateChangesForEvent:(Event*)event;
-(void)initiateWithEventInfo:(Event *)event;

@end
