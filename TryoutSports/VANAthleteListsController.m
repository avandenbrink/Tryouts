//
//  VANAthleteListsController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-26.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteListsController.h"

@interface VANAthleteListsController ()

@end

@implementation VANAthleteListsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.athleteList = (NSMutableArray *)[self.event.athletes allObjects];
    NSLog(@"Atheltes: %lu", (unsigned long)[self.athleteList count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //return [self.athleteList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.athleteList count];
    
    //NSArray *subArray = [self.athleteList objectAtIndex:section];
    //return [subArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Athlete *athlete = [self.athleteList objectAtIndex:indexPath.row];
    //NSArray *subArray = [self.athleteList objectAtIndex:indexPath.section];
    //Athlete *athelte = [subArray objectAtIndex:indexPath.row];
    cell.textLabel.text = athlete.name;
    return cell;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
