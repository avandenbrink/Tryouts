//
//  VANTeamTableView.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-14.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTeamTableView.h"
#import "Athlete.h"
#import "Positions.h"
#import "VANTeamsController.h"

@implementation VANTeamTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.positions count] + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.array objectAtIndex:section] count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([indexPath section] < [self.array count]) {
        
        Athlete *athlete = [[self.array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = athlete.name;
    } else {
        
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < [self.positions count]) {
        Positions *position = [self.positions objectAtIndex:section];
        return position.position;
    } else {
        return @"No Position Selected";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.controller performSegueWithIdentifier:@"toAthlete" sender:[[self.array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([[self.array objectAtIndex:section] count] < 1) {
        return [NSString stringWithFormat:@"You Don't have any athletes selected to this position yet."];
    } else {
            return nil;
    }
}


@end
