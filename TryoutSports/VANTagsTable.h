//
//  VANTagsTable.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/6/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTableView.h"
#import "VANAthleteListControllerPad.h"

@interface VANTagsTable : VANTableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) VANAthleteListControllerPad *delegateController;
@property (strong, nonatomic) NSMutableArray *selectedTagsArray;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property (strong, nonatomic) UISegmentedControl *filterSegment;

-(void)resetTagsFiltertoAll;
-(void)sortTagArrays;

@end
