//
//  VANAthleteNameViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteNameViewController.h"

@interface VANAthleteNameViewController ()

@property (strong, nonatomic) NSMutableArray *athleteArray;

@end

@implementation VANAthleteNameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.athleteArray = (NSMutableArray *)[self.event.athletes allObjects];
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [self.athleteArray sortedArrayUsingDescriptors:@[sortDescriptorName]];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Athlete *athlete = [self.athleteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = athlete.name;
    return cell;

}

@end
