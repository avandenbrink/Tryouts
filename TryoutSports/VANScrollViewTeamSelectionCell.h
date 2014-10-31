//
//  VANScrollViewTeamSelectionCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-21.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"

@protocol VANScrollViewDelegate <NSObject>

-(void)hasUpdatedAthleteTeam;

@end

@interface VANScrollViewTeamSelectionCell : UITableViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) id <VANScrollViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (strong, nonatomic) UIView *viewer;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic) Athlete *athlete;

- (void)initiate;
- (IBAction)changeScrollerfromController:(id)sender;
- (void)setTeamPageForAthlete:(Athlete *)athlete;
- (void)resizeTeamViewstoControllerViewSize:(CGSize *)size;

@end
