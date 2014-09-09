//
//  VANDecisionRoomViewControllerPad.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/19/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDecisionRoomViewControllerPad.h"
#import "VANCompareController.h"
#import "AthleteSkills.h"
#import "AthleteTest.h"
#import "AthleteTags.h"

@interface VANDecisionRoomViewControllerPad ()

@property (strong, nonatomic) NSArray *topAthletesArray;
@property (strong, nonatomic) NSArray *topAllAthletesArray;
@property (strong, nonatomic) NSArray *topNoTeamAthletesArray;

@end

@implementation VANDecisionRoomViewControllerPad

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
    
    [self.topTabBar setSelectedItem:self.allTopAthletes];

    BOOL allAthletes = YES;
	// Do any additional setup after loading the view.
    if ([self.topTabBar.selectedItem isEqual:self.allNoTeamTopAthletes]) {
        allAthletes = NO;
    }
    [self buildAllTopAthletesArray:allAthletes whileUpdatingScore:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)compareAthletes:(id)sender
{
    [self performSegueWithIdentifier:@"toCompareController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCompareController"]) {
        VANCompareController *controller = segue.destinationViewController;
        controller.event = self.event;
    }
}


#pragma mark - Setup View Methods

-(void)buildAllTopAthletesArray:(BOOL)all whileUpdatingScore:(BOOL)update {
    
    NSArray *allAthletes = [self.event.athletes allObjects];
    NSMutableArray *topAthleteList = [NSMutableArray array];
    
    if (update) {
        
        //Set the Mean and Standard Deviation for Each Test
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AthleteTest"];
        NSArray *testNames = [self.event.tests allObjects];
        NSMutableDictionary *allTestData = [NSMutableDictionary dictionary];
        
        for (Tests *test in testNames) {
            NSPredicate *filterByName = [NSPredicate predicateWithFormat:@"attribute LIKE %@", test.descriptor];
            [request setPredicate:filterByName];
            NSArray *testWithName = [self.event.managedObjectContext executeFetchRequest:request error:nil];
            float mean = 0;
            int noValue = 0;
            NSMutableArray *values = [NSMutableArray array];
            for (AthleteTest *testValue in testWithName) {
                if (testValue.value) {
                    mean += [testValue.value intValue];
                    [values addObject:[NSNumber numberWithFloat:[testValue.value floatValue]]];
                } else {
                    noValue++;
                }
            }
            float sum = [testWithName count]-noValue;
            mean = mean/sum;
            float dev = 0;
            for (NSNumber *num in values) {
                float numberLessMean = [num floatValue] - mean;
                dev += numberLessMean * numberLessMean;
            }
            NSNumber *standardDev = [NSNumber numberWithFloat:sqrtf(dev/[values count])];
            NSDictionary *data = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithFloat:mean],standardDev] forKeys:@[@"mean",@"dev"]];
            [allTestData setValue:data forKey:test.descriptor];
        }
        
        for (Athlete *athlete in allAthletes) {
            float athleteScore = 0;
            
            
            //This Formula will have to be manupulated in the future to give the correct weight to each of the value types but right now includes:
            //Average Score of all Skills built
            //+1 for each positive tag, and -1 for each negative tag
            //The acutal value of each of the Tests
            
            
            
            //Add Skills Value Score;
            NSArray *skills = [athlete.skills allObjects];
            float skillScore = 0;
            float missedSkills = 0;
            for (AthleteSkills *skill in skills) {
                if (skill.value) {
                    skillScore += [skill.value floatValue];
                } else {
                    missedSkills++;
                }
            }
            skillScore = skillScore/([[athlete.skills allObjects] count]-missedSkills);
            athleteScore += skillScore;
            
            //Add Tags Value Score;
            NSArray *tags = [athlete.aTags allObjects];
            float tagScore = 0;
            for (AthleteTags *tag in tags) {
                if ([tag.type isEqualToNumber:[NSNumber numberWithFloat:0]]) {
                    tagScore++;
                } else if ([tag.type isEqualToNumber:[NSNumber numberWithFloat:2]]) {
                    tagScore--;
                }
            }
            athleteScore += tagScore;
            
            //Add Tests Values
            NSArray *tests = [athlete.tests allObjects];
            float testsScore = 0;
            float missedTest = 0;
            for (AthleteTest *athleteTest in tests) {
                NSDictionary *testData = [allTestData valueForKey:athleteTest.attribute];
                NSNumber *testMean = [testData valueForKey:@"mean"];
                NSNumber *testDev = [testData valueForKey:@"dev"];
                float testScore = ([athleteTest.value floatValue]-[testMean floatValue])/[testDev floatValue];
                testsScore += testScore*2;
            }
            
            
            athleteScore += testsScore;
            athlete.valueScore = [NSNumber numberWithFloat:athleteScore];
            [topAthleteList addObject:athlete];
        }
    }
    
    if (all) {
        if (!self.topAllAthletesArray) {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"valueScore" ascending:NO];
            self.topAllAthletesArray = [[self.event.athletes allObjects] sortedArrayUsingDescriptors:@[sort]];
        }
        self.topAthletesArray = self.topAllAthletesArray;
        
    } else {
        if (!self.topNoTeamAthletesArray) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamSelected = nil"];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"valueScore" ascending:NO];
            self.topNoTeamAthletesArray = [[[self.event.athletes allObjects] filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        }
        self.topAthletesArray = self.topNoTeamAthletesArray;

    }
    
    [self.topTableView reloadData];
}

#pragma mark - Tab Bar Methods

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item isEqual:self.allNoTeamTopAthletes]) {
        [self buildAllTopAthletesArray:NO whileUpdatingScore:NO];
    } else {
        [self buildAllTopAthletesArray:YES whileUpdatingScore:NO];
    }

}

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topAthletesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    Athlete *athlete = [self.topAthletesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = athlete.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f", [athlete.valueScore floatValue]];
    if (athlete.teamSelected > 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Top Ranked Athletes";
}

@end
