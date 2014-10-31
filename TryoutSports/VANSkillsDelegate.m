//
//  VANSkillsDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANSkillsDelegate.h"

@implementation VANSkillsDelegate


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Skills";
}

-(void)collectValuesFromTable {
    self.data.skills = self.values;
}

@end
