//
//  VANTeamTableView.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-14.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VANTeamsController;
@class Athlete;

@interface VANTeamTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) VANTeamsController *controller;
@property (strong, nonatomic) NSArray *positions;
@property (nonatomic) NSUInteger team;

@end
