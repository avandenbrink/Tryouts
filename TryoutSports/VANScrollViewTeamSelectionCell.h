//
//  VANScrollViewTeamSelectionCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-21.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"

@interface VANScrollViewTeamSelectionCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (strong, nonatomic) UIView *viewer;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic) Athlete *athlete;

- (void)initiate;
- (IBAction)changeScrollerfromController:(id)sender;
- (void)gotoPageWithAnimation:(BOOL)animated;

- (void)resizeTeamViewstoControllerViewSize:(CGSize *)size;

@end
