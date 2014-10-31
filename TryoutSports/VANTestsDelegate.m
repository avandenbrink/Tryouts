//
//  VANTestsDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANTestsDelegate.h"

@implementation VANTestsDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tests";
}

-(void)collectValuesFromTable {
    self.data.tests = self.values;
}

@end
