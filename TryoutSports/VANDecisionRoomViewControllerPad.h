//
//  VANDecisionRoomViewControllerPad.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/19/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDecisionRoomViewController.h"

@interface VANDecisionRoomViewControllerPad : VANDecisionRoomViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (weak, nonatomic) IBOutlet UITabBar *topTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *allTopAthletes;
@property (weak, nonatomic) IBOutlet UITabBarItem *allNoTeamTopAthletes;

@end
