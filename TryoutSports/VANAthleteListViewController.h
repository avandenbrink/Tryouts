//
//  VANAthleteListViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectViewController.h"
#import "VANAthleteEditController.h"
#import "VANComparisonController.h"
#import "VANAthleteListCell.h"


@interface VANAthleteListViewController : VANManagedObjectViewController <UITabBarDelegate, UIGestureRecognizerDelegate, VANAthleteListCellDelegate>

@property (nonatomic, weak) VANComparisonController *compareDelegate;
@property (strong, nonatomic) NSMutableArray *athleteList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak ,nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) VANTeamColor *teamColor;

@property (nonatomic, assign) NSInteger currentFlagged;

@property (nonatomic, assign) BOOL shouldReloadCache;

- (void)removeImagesFromProfileCache:(NSArray *)images;
- (IBAction)addNewAthlete:(id)sender;
- (void)setupAthleteListCell:(VANAthleteListCell *)cell withAthlete:(Athlete *)athlete forIndexPath:(NSIndexPath *)indexPath;


@end
