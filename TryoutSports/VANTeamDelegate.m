//
//  VANTeamDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-29.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANTeamDelegate.h"

@implementation VANTeamDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Teams";
}

-(void)collectValuesFromTable {
    self.data.teams = self.values;
}

@end
