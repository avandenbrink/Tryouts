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
    
    NSArray *athleteArray = [self fetchAthleteTeams];
    self.teamsArray = [self organizeAthletesIntoTeams:athleteArray];
    //Building Team Scrollers, Need to come back to Remove the athlete on team 0 (aka Unselected)
        self.scrollerView.contentSize = CGSizeMake(([self.teamsArray count])*320, self.scrollerView.frame.size.height);
    
        for (NSInteger i = 1; i <= [self.teamsArray count]; i++) {
            NSLog(@"Adding new Table");
            VANTeamTableView *tableView = [[VANTeamTableView alloc] initWithFrame:CGRectMake((320 * i)-320, 0, 320, self.scrollerView.frame.size.height - 0) style:UITableViewStyleGrouped];
            [tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
            //Athlete *athlete = [self.athletArray objectAtIndex:i];
//            NSPredicate *teamsSelector = [NSPredicate predicateWithFormat:@"teamSelected = %lu", i];
        //Insert NSPredicate Information Here to Filter athleteArray based on their team number i
            tableView.positions = [self.event.positions allObjects];
            tableView.array = (NSMutableArray *)[self.teamsArray objectAtIndex:i-1];
            tableView.controller = self;
            [self.scrollerView addSubview:tableView];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, self.scrollerView.frame.origin.y, 320, 40)];
            view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            view.alpha = 0.9f;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            label.text = [NSString stringWithFormat:@"Team: %ld", (long)i];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            if (i != [self.teamsArray count]) {
                NSLog(@"Adding ArrowRight");
                UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-view.frame.size.height-10, 0, view.frame.size.height, view.frame.size.height)];
                [right setImage:[UIImage imageNamed:@"ArrowRight.png"] forState:UIControlStateNormal];
                [right addTarget:self action:@selector(nextTeam) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:right];
            }
            if (i != 1) {
                NSLog(@"Adding ArrowRight");
                UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.height, view.frame.size.height)];
                [left setImage:[UIImage imageNamed:@"ArrowLeft.png"] forState:UIControlStateNormal];
                [left addTarget:self action:@selector(prevTeam) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:left];
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line];
            
            
            [self.scrollerView addSubview:view];
            UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake(self.scrollerView.frame.size.width-1, 0, 1, self.scrollerView.frame.size.height)];
            vertLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:vertLine];
        }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
 //   NSArray *array = [self fetchAthleteTeams];
 //   self.teamsArray = [self organizeAthletesIntoTeams:array];
    for (NSInteger i = 0; i < [self.scrollerView.subviews count]; i++) {
        if ([[self.scrollerView.subviews objectAtIndex:i] isKindOfClass:[VANTeamTableView class]]) {
            VANTeamTableView *table = [self.scrollerView.subviews objectAtIndex:i];
            [table reloadData];
        }
    }
    if (self.updateAthlete != nil) {
        [self attemptToUpdateSingleAthlete:self.updateAthlete];
    }
}

-(void)nextTeam {
    CGPoint currentPlace = self.scrollerView.contentOffset;
    NSLog(@"Current %f", currentPlace.x);
    CGPoint moveTo = CGPointMake(currentPlace.x+self.scrollerView.frame.size.width,currentPlace.y);
    [self.scrollerView setContentOffset:moveTo animated:YES];
}

-(void)prevTeam {
    CGPoint currentPlace = self.scrollerView.contentOffset;
    NSLog(@"Current %f", currentPlace.x);
    CGPoint moveTo = CGPointMake(currentPlace.x-self.scrollerView.frame.size.width,currentPlace.y);
    [self.scrollerView setContentOffset:moveTo animated:YES];
}

-(void)attemptToUpdateSingleAthlete:(Athlete *)athlete {
    
    //Find the Team they were associated with
    NSInteger teamIndex = NSNotFound;
    if ([athlete.teamSelected integerValue] != 0) {
        teamIndex = [athlete.teamSelected integerValue]-1;
    }
    NSInteger previousTeamIndex = self.scrollerView.contentOffset.x/self.view.frame.size.width;
    
    NSInteger newPositionIndex = NSNotFound;
    for (NSInteger i = 0; i < [self.event.positions count]; i++) {
        Positions *pos = [[self.event.positions allObjects] objectAtIndex:i];
        if ([pos.position isEqualToString:self.updateAthlete.position]) {
            newPositionIndex = i;
        }
    }
    if (newPositionIndex == NSNotFound) {
        NSLog(@"Warning: Position is == NOT Found");
    }
    
    //If the Athletes Team has Changed:
    if (teamIndex != previousTeamIndex) {

        //Find the TableView associated with The Athlete

        if ([[self.scrollerView.subviews objectAtIndex:previousTeamIndex*2] isKindOfClass:[VANTeamTableView class]]) {
            VANTeamTableView *oldTable = [self.scrollerView.subviews objectAtIndex:(previousTeamIndex*2)];
            [[oldTable.array objectAtIndex:self.updatedAthleteIndexPath.section] removeObjectAtIndex:self.updatedAthleteIndexPath.row];
            NSLog(@"%lu", (unsigned long)[[[self.teamsArray objectAtIndex:previousTeamIndex] objectAtIndex:self.updatedAthleteIndexPath.section] count]);
          //  [[[self.teamsArray objectAtIndex:previousTeamIndex] objectAtIndex:self.updatedAthleteIndexPath.section] removeObjectAtIndex:self.updatedAthleteIndexPath.row-1];
            [oldTable deleteRowsAtIndexPaths:@[self.updatedAthleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            NSLog(@"Warning VANTeamsController, objectATIndex is not a TableView");
        }
        if (teamIndex != NSNotFound) {

            if ([[self.scrollerView.subviews objectAtIndex:teamIndex*2] isKindOfClass:[VANTeamTableView class]]) {
                VANTeamTableView *newTable = [self.scrollerView.subviews objectAtIndex:(teamIndex*2)];
                [[newTable.array objectAtIndex:newPositionIndex] addObject:self.updateAthlete];
                //     [[[self.teamsArray objectAtIndex:teamIndex] objectAtIndex:self.updatedAthleteIndexPath.section] addObject:self.updateAthlete];
                [newTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[newTable.array objectAtIndex:newPositionIndex] count]-1 inSection:newPositionIndex]] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                NSLog(@"Warning VANTeamsController, objectATIndex is not a TableView");
            }
        }
        
    } else { // Else check to see if anything else has changed
        
        //Check to see if just the Team has changed
        
        NSInteger previousPositionIndex = self.updatedAthleteIndexPath.section;
        
        if (newPositionIndex != previousPositionIndex) {
            VANTeamTableView *table = [self.scrollerView.subviews objectAtIndex:(previousTeamIndex*2)];
            [[table.array objectAtIndex:previousPositionIndex] removeObjectAtIndex:self.updatedAthleteIndexPath.row];
            [[table.array objectAtIndex:newPositionIndex] addObject:self.updateAthlete];
            
            [table moveRowAtIndexPath:self.updatedAthleteIndexPath toIndexPath:[NSIndexPath indexPathForRow:[[table.array objectAtIndex:newPositionIndex] count]-1 inSection:newPositionIndex]];

        }
    }

    self.updateAthlete = nil;
    self.updatedAthleteIndexPath = nil;
}

-(NSMutableArray *)organizeAthletesIntoTeams:(NSArray *)array {
    NSArray *position = [self.event.positions allObjects];
    NSMutableArray *teamsArray = [NSMutableArray array];
    
//    for (NSInteger i = 1; i < [self.event.numTeams integerValue]; i++) {
//        NSMutableArray *team = [NSMutableArray array];
//        for (NSInteger x = 0; x < [position count]; x++) {
//            NSMutableArray *pos = [NSMutableArray array];
//            [team addObject:pos];
//        }
//        [team addObject:[NSMutableArray array]];
//        [teamsArray addObject:team];
//    }
    
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
