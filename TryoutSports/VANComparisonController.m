//
//  VANComparisonController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANComparisonController.h"
#import "VANAthleteListTabController.h"
#import "VANAthleteNameViewController.h"
#import "VANCompareImageCell.h"
#import "VANCompareNameCell.h"
#import "VANCompareStatsCell.h"
#import "VANCompareTagsCell.h"
#import "AthleteTags.h"
#import "AthleteSkills.h"
#import "AthleteTest.h"

static NSString *kSkill = @"skill";
static NSString *kTest = @"test";
static NSString *kType = @"type";
static NSString *kValue = @"value";

@interface VANComparisonController ()

@property (strong, nonatomic) NSArray *statLabels;

@end

@implementation VANComparisonController

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
    NSMutableArray *skillArray = [NSMutableArray array];
    NSMutableArray *testsArray = [NSMutableArray array];
    NSArray *skills = [self.event.skills allObjects];
    NSArray *tests = [self.event.tests allObjects];
    
    for (NSInteger i = 0 ; i < [skills count]; i++) {
        Skills *skill = [skills objectAtIndex:i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[skill.descriptor, kSkill] forKeys:@[kValue,kType]];
        [skillArray addObject:dic];
    }
    
    for (NSInteger x = 0; x < [tests count]; x++) {
        Tests *test = [tests objectAtIndex:x];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[test.descriptor, kTest] forKeys:@[kValue,kType]];
        [testsArray addObject:dic];
    }
    
    self.statLabels = [skillArray arrayByAddingObjectsFromArray:testsArray];
}

-(void)viewWillAppear:(BOOL)animated {
    if (!self.athleteA) {
        self.changeA.titleLabel.text = @"Select Athlete";
    } else {
        self.changeA.titleLabel.text = @"Change Athlete";
    }
    if (!self.athleteB) {
        self.changeB.titleLabel.text = @"Select Athlete";
    } else {
        self.changeB.titleLabel.text = @"Change Athlete";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return [self.statLabels count] + 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellIDpic = @"compareImage";
            VANCompareImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDpic];
            if (self.athleteA) {
                UIImage *image = [[self.athleteA.headShotImage allObjects] objectAtIndex:0];
                cell.athleteA.image = image;
            }
            
            if (self.athleteB) {
                UIImage *image = [[self.athleteB.headShotImage allObjects] objectAtIndex:0];
                cell.athleteB.image = image;
            }
            
            return cell;
        } else {
            static NSString *cellIDName = @"compareName";
            VANCompareNameCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDName];
            if (self.athleteA) {
                cell.athleteA.text = self.athleteA.name;
            } else {
                cell.athleteA.text = @"";
            }
            if (self.athleteB) {
                cell.athleteB.text = self.athleteB.name;
            } else {
                cell.athleteB.text = @"";
            }
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            static NSString *cellIDTag = @"compareTags";
            VANCompareTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDTag];
            if (self.athleteA) {
                if ([self.athleteA.aTags count] > 0) {
                    NSArray *array = [self.athleteA.aTags allObjects];
                    NSString *tags = [NSMutableString string];
                    for (AthleteTags *tag in array) {
                        tags = [tags stringByAppendingString:[NSString stringWithFormat:@"%@, ",tag.descriptor]];
                    }
                    cell.athleteATags.text = tags;
                } else {
                    cell.athleteATags.text = @"No Characteristics";
                }
            }
            
            if (self.athleteB) {
                if ([self.athleteB.aTags count] > 0) {
                    NSArray *array = [self.athleteB.aTags allObjects];
                    NSString *tags = [NSMutableString string];
                    for (AthleteTags *tag in array) {
                        tags = [tags stringByAppendingString:[NSString stringWithFormat:@"%@, ",tag.descriptor]];
                    }
                    cell.athleteBTags.text = tags;
                } else {
                    cell.athleteBTags.text = @"No Characteristics";
                }
            }
            return cell;
        } else {
            static NSString *cellIDStats = @"compareStats";
            VANCompareStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStats];
            
            if (indexPath.row == 1) {
                cell.athleteStat.text = @"All Skills";
                
                if (self.athleteA) {
                    
                } else {
                    cell.athleteAValue.text = @"NA";
                }
                
                if (self.athleteB) {
                    
                } else {
                    cell.athleteBValue.text = @"NA";
                }
            } else {
                NSDictionary *dic = [self.statLabels objectAtIndex:indexPath.row -2];
                NSString *value = [dic valueForKey:kValue];
                cell.athleteStat.text = value;
                
                if (self.athleteA) {
                    id value = [self searchAthlete:self.athleteA forStat:dic];
                    cell.athleteAValue.text = [NSString stringWithFormat:@"%@", value];
                } else {
                    cell.athleteAValue.text = @"NA";
                }
                
                if (self.athleteB) {
                    id value = [self searchAthlete:self.athleteB forStat:dic];
                    cell.athleteBValue.text = [NSString stringWithFormat:@"%@", value];
                } else {
                    cell.athleteBValue.text = @"NA";
                }
            }
            return cell;
        }
    }
}

-(id)searchAthlete:(Athlete *)athlete forStat:(NSDictionary *)dic {
    NSString *key = [dic valueForKey:kType];
    NSString *value = [dic valueForKey:kValue];
    if ([key isEqualToString:kSkill]) {
        NSArray *skills = [athlete.skills allObjects];
        for (NSInteger i = 0; i < [skills count]; i++) {
            AthleteSkills *skill = [skills objectAtIndex:i];
            if ([skill.attribute isEqualToString:value]) {
                return skill.value;
            }
        }
        NSLog(@"Warning, Call returned Nil Value, ComparisonController");
        return nil;
    } else {
        NSArray *tests = [athlete.tests allObjects];
        for (NSInteger i = 0; i < [tests count]; i++) {
            AthleteTest *test = [tests objectAtIndex:i];
            if ([test.attribute isEqualToString:value]) {
                return test.value;
            }
        }
        NSLog(@"Warning, Call returned Nil Value, ComparisonController");
        return nil;
    }
}

#pragma mark - Table View Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 159;
    } else {
        return 50;
    }
}


#pragma mark - Custom Built Methods

- (IBAction)changeAthlete:(id)sender {
    [self performSegueWithIdentifier:@"toChangeAthlete" sender:self.event];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toChangeAthlete"]) {
        VANAthleteListTabController *tabBarController = segue.destinationViewController;
        tabBarController.delegate = tabBarController;
        tabBarController.event = sender;
        tabBarController.selectedIndex = 0;
        if (tabBarController.selectedIndex == 0) {
            VANAthleteNameViewController *controller = (VANAthleteNameViewController *)[tabBarController.viewControllers objectAtIndex:0];
            controller.event = sender;
        }
    }
}


@end
