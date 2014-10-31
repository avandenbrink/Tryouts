//
//  VANAthleteAdderController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteAddObject.h"

@interface VANAthleteAddObject ()

@end

@implementation VANAthleteAddObject

//This SubClass should only manage the Table View Data and Delegate Methods that are custom to this view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"1. Import from .csv (excel) file";
            break;
        case 1:
            cell.textLabel.text = @"2. Input Names manually";
            break;
        case 2:
            cell.textLabel.text = @"3. Use Athlete sign-in";
            break;
        default:
            break;
    }
    return cell;
}




-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"How to Import a file";
            break;
            
        case 1:
            return @"How to Import manually";
            break;
            
        case 2:
            return @"How to use Sign-in";
            break;
            
        default:
            return @"";
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
