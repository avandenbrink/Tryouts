//
//  VANAthleteProfileCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANNewAthleteProfileCell.h"
#import "VANMotherCell.h"

@class VANAthleteProfileCell;

@protocol VANAthleteProfileDelegate <NSObject>

-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell;
-(void)VANTableViewCellrequestsImageInFullScreen:(UIImage *)image fromCell:(VANAthleteProfileCell *)cell;

@end


@interface VANAthleteProfileCell : VANMotherCell <UIScrollViewDelegate>

@property (nonatomic, weak) id <VANAthleteProfileDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIView *content;

-(void)setup;
-(void)addOrSubtrackViews;
-(void)attachImages;
-(void)activateCameraPressed;
-(void)addNewImageFromData:(NSData *)imageData;


@end
