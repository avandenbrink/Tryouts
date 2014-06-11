//
//  VANAthleteListCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VANAthleteListCell;

typedef NS_ENUM(NSUInteger, swipeTableViewCellState) {
    swipeTableViewCellStateNone = 0,
    swipeTableViewCellState1,
    swipeTableViewCellState2,
    swipeTableViewCellState3,
    swipeTableViewCellState4
};

typedef NS_ENUM(NSUInteger, swipeTableViewCellDirection) {
    swipeTableViewCellDirectionLeft = 0,
    swipeTableViewCellDirectionCenter,
    swipeTableViewCellDirectionRight
};

typedef NS_ENUM(NSUInteger, swipeTableViewCellMode) {
    swipeTableViewCellModeNone = 0,
    swipeTableViewCellModeExit,
    swipeTableViewCellModeSwitch
};

@protocol VANAthleteListCellDelegate <NSObject>

@optional

// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(VANAthleteListCell *)cell;

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(VANAthleteListCell *)cell;

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(VANAthleteListCell *)cell didSwipeWithPercentage:(CGFloat)percentage;

// When the user releases the cell, after swiping it, this method is called
- (void)swipeTableViewCell:(VANAthleteListCell *)cell didEndSwipingSwipingWithState:(swipeTableViewCellState)state mode:(swipeTableViewCellMode)mode;

@end

@interface VANAthleteListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *athleteHeadshot;
@property (weak, nonatomic) IBOutlet UILabel *aNumber;
@property (weak, nonatomic) IBOutlet UILabel *aNumberImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *seenImg;
@property (nonatomic, assign) BOOL isFlagged;
@property (weak, nonatomic) IBOutlet UIImageView *keyedImg;
@property (weak, nonatomic) IBOutlet UIView *numberBG;
@property (weak, nonatomic) IBOutlet UIView *teamBG;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;


@property (nonatomic, weak) id <VANAthleteListCellDelegate> delegate;

@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, assign) CGFloat firstTrigger;

@property (nonatomic, strong) UIColor *defaultColor;

@property (nonatomic, assign) swipeTableViewCellMode mode;

@property (nonatomic, assign) swipeTableViewCellMode modeForState1;
@property (nonatomic, assign) swipeTableViewCellMode modeForState2;
@property (nonatomic, assign) swipeTableViewCellMode modeForState3;
@property (nonatomic, assign) swipeTableViewCellMode modeForState4;

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL shouldDrag;

-(void)initializer;


@end
