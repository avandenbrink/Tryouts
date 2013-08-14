//
//  VANTeamsController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-23.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTeamsController.h"
#import "VANTeamTableView.h"
#import "VANAthleteDetailController.h"

@interface VANTeamsController ()

@property (strong, nonatomic) NSArray *teamsArray;

@end

@interface VANTeamsController ()

@end

@implementation VANTeamsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Did Load");
    NSArray *athleteArray = [self fetchAthleteTeams];
    self.teamsArray = [self organizeAthletesIntoTeams:athleteArray];
    //Building Team Scrollers, Need to come back to Remove the athlete on team 0 (aka Unselected)
        self.scrollerView.contentSize = CGSizeMake(([self.teamsArray count])*320, self.scrollerView.frame.size.height);
    
        for (NSInteger i = 1; i <= [self.teamsArray count]; i++) {
            NSLog(@"Adding new Table");
            VANTeamTableView *tableView = [[VANTeamTableView alloc] initWithFrame:CGRectMake((320 * i)-320, 40, 320, self.scrollerView.frame.size.height - 40) style:UITableViewStyleGrouped];
            //Athlete *athlete = [self.athletArray objectAtIndex:i];
//            NSPredicate *teamsSelector = [NSPredicate predicateWithFormat:@"teamSelected = %lu", i];
        //Insert NSPredicate Information Here to Filter athleteArray based on their team number i
            tableView.positions = [self.event.positions allObjects];
            tableView.array = (NSMutableArray *)[self.teamsArray objectAtIndex:i-1];
            tableView.controller = self;
            [self.scrollerView addSubview:tableView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, self.scrollerView.frame.origin.y, 320, 40)];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            label.text = [NSString stringWithFormat:@"Team: %ld", (long)i];
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            label.textAlignment = NSTextAlignmentCenter;
        
            [self.scrollerView addSubview:label];
        }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"View Will Appear");
    
    NSArray *array = [self fetchAthleteTeams];
    self.teamsArray = [self organizeAthletesIntoTeams:array];
    for (NSInteger i = 0; i < [self.scrollerView.subviews count]; i++) {
        if ([[self.scrollerView.subviews objectAtIndex:i] isKindOfClass:[VANTeamTableView class]]) {
            VANTeamTableView *table = [self.scrollerView.subviews objectAtIndex:i];
            [table reloadData];
        }
    }
    
    
}

-(NSMutableArray *)organizeAthletesIntoTeams:(NSArray *)array {
    NSArray *position = [self.event.positions allObjects];
    NSMutableArray *teamsArray = [NSMutableArray array];
    
    for (NSInteger i = 1; i < [self.event.numTeams integerValue]; i++) {
        NSMutableArray *team = [NSMutableArray array];
        for (NSInteger x = 0; x < [position count]; x++) {
            NSMutableArray *pos = [NSMutableArray array];
            [team addObject:pos];
        }
        [team addObject:[NSMutableArray array]];
        [teamsArray addObject:team];
    }
    
    for (NSInteger i = 0; i < [array count]; i++) {
        Athlete *athlete = [array objectAtIndex:i];
        NSArray *team = [teamsArray objectAtIndex:[athlete.teamSelected integerValue]-1];
        if (athlete.position == nil) {
            NSMutableArray *noPos = [team objectAtIndex:team.count-1];
            [noPos addObject:athlete];
        } else {
            for (NSInteger x = 0; x < [position count]; x++) {
                Positions *p = [position objectAtIndex:x];
                if ([athlete.position isEqualToString:p.position]) {
                    NSMutableArray *pos = [team objectAtIndex:x];
                    [pos addObject:athlete];
                }
            }
        }
    }

    return teamsArray;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)fetchAthleteTeams {
    NSManagedObjectContext *context = [self.event managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Athlete"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(self.event == %@) AND (self.teamSelected > 0)", self.event];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSMutableArray *array = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    if (array != nil) {
        //
        return array;
    }
    else {
        // Deal with error.
        NSLog(@"Failed to Return Athletes");
        return nil;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAthlete"]) {
        VANAthleteDetailController *controller = segue.destinationViewController;
        controller.event = self.event;
        controller.athlete = sender;
    }
}


@end
