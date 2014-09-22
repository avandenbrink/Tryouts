//
//  VANEditAthletesViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-09-19.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANEditAthletesViewController.h"
#import "VANAthleteEditController.h"

static NSString *toAthleteDetail = @"athleteDetail";

@interface VANEditAthletesViewController ()

@property (strong, nonatomic) NSArray *athleteList;

@end

@implementation VANEditAthletesViewController

-(void)setEvent:(Event *)event {
    [super setEvent:event];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.athleteList = [[event.athletes allObjects] sortedArrayUsingDescriptors:@[sortByName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.athleteList = [[self.event.athletes allObjects] sortedArrayUsingDescriptors:@[sortByName]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Sources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.athleteList count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    
    if (indexPath.row == [self.athleteList count]) {
        cell.detailTextLabel.text = @"Add more...";
        cell.textLabel.text = @"";
    } else {
        Athlete * a = [self.athleteList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = a.name;
        cell.textLabel.text = [a.number stringValue];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"You can add multiple athletes at the same time by importing a .csv file with the data included. The simplest way to do this is to email the .csv to yourself and then long touch the file in your mail app, then select open with Tryout Sports.";
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Athlete *athlete = nil;
    if (indexPath.row != [self.athleteList count]) {
        athlete = [self.athleteList objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:toAthleteDetail sender:athlete];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toAthleteDetail]) {
        VANAthleteEditController *controller = segue.destinationViewController;
        controller.athlete = sender;
        controller.event = self.event;
        controller.delegate = self;
        
        if (sender == nil) {
            controller.isNew = YES;
        }
    }
}

#pragma mark - Edit Athlete Delegate Methods

-(void)closeAthleteEditPopover {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
