//
//  VANMainMenuViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANIntroViewController.h"
#import "Event.h"
#import "VANAthleteListViewController.h"
#import "VANAthleteProgressView.h"

@class VANTagsViewController;

@interface VANMainMenuViewController : VANManagedObjectViewController <UIScrollViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSUInteger selectedColorIndex;
@property (strong, nonatomic) UIColor *teamColor;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *athleteSignIn;

@property (weak, nonatomic) IBOutlet VANAthleteProgressView *athleteStatView;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet VANTagsViewController *controller;

- (IBAction)pushtoEventSettings:(id)sender;
- (IBAction)pushToAthleteList:(id)sender;
- (IBAction)editSkills:(id)sender;
- (IBAction)toTeams:(id)sender;
- (IBAction)toConnectCentre:(id)sender;
- (IBAction)toDecisionRoom:(id)sender;


@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (nonatomic, strong) NSMutableArray *pageViews;






@end
