//
//  VANPositionsDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANPositionsDelegate.h"

@implementation VANPositionsDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Positions";
}

-(void)collectValuesFromTable {
    self.data.positions = self.values;
}


@end
