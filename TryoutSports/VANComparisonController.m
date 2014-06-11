//
//  VANComparisonController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANComparisonController.h"
#import "VANAthleteListViewController.h"
#import "VANAthleteNameViewController.h"
#import "VANCompareImageCell.h"
#import "VANCompareNameCell.h"
#import "VANCompareStatsCell.h"
#import "VANCompareTagsCell.h"
#import "AthleteTags.h"
#import "AthleteSkills.h"
#import "AthleteTest.h"
#import "Image.h"

static NSString *kSkill = @"skill";
static NSString *kTest = @"test";
static NSString *kType = @"type";
static NSString *kValue = @"value";

@interface VANComparisonController ()

@property (strong, nonatomic) NSArray *statLabels;
@property (nonatomic) NSInteger changeAthlete;
@property (strong, nonatomic) VANTeamColor *teamColor;

//Scroll Dection
@property (nonatomic, assign) NSInteger lastContentOffset;

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
    self.changeA.layer.opacity = 0.8;
    self.changeB.layer.opacity = 0.8;
    self.statLabels = [skillArray arrayByAddingObjectsFromArray:testsArray];
    self.teamColor = [[VANTeamColor alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    if (!self.athleteA) {
        [self.changeA setTitle:@"Select Athlete" forState:UIControlStateNormal];
    } else {
        [self.changeA setTitle:@"Change Athlete" forState:UIControlStateNormal];
    }
    if (!self.athleteB) {
        [self.changeB setTitle:@"Select Athlete" forState:UIControlStateNormal];
    } else {
        [self.changeB setTitle:@"Change Athlete" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return [self.statLabels count] + 1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellIDpic = @"compareImage";
            VANCompareImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDpic];
            if (self.athleteA) {
                NSArray *array = [self.athleteA.images allObjects];
                if ([array count] > 0) {
                    Image *imageData = [array objectAtIndex:0];
                    UIImage *image = [UIImage imageWithData:imageData.headShot];
                    cell.athleteA.image = image;
                } else {
                    cell.athleteA.image = nil;
                }
            }
            if (self.athleteB) {
                NSArray *array = [self.athleteB.images allObjects];
                if ([array count] > 0) {
                    Image *imageData = [array objectAtIndex:0];
                    UIImage *image = [UIImage imageWithData:imageData.headShot];
                    cell.athleteB.image = image;
                } else {
                    cell.athleteB.image = nil;
                }
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
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *cellIDStats = @"compareStats";
            VANCompareStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStats];

            cell.athleteStat.text = @"All Skills";
            NSInteger allSkillsValueA = 0;
            NSInteger allSkillsValueB = 0;
            
            if (self.athleteA) {
                NSArray *skills = [self.athleteA.skills allObjects];
                
                for (NSInteger i = 0; i < [skills count]; i++) {
                    AthleteSkills *skill = [skills objectAtIndex:i];
                    allSkillsValueA += [skill.value integerValue];
                }
                cell.athleteAValue.text = [NSString stringWithFormat:@"%ld", (long)allSkillsValueA];
            } else {
                cell.athleteAValue.text = @"NA";
            }
            
            if (self.athleteB) {
                NSArray *skills = [self.athleteB.skills allObjects];
                for (NSInteger i = 0; i < [skills count]; i++) {
                    AthleteSkills *skill = [skills objectAtIndex:i];
                    allSkillsValueB += [skill.value integerValue];
                }
                cell.athleteBValue.text = [NSString stringWithFormat:@"%ld", (long)allSkillsValueB];
            } else {
                cell.athleteBValue.text = @"NA";
            }
            
            if (allSkillsValueA > allSkillsValueB) {
                cell.athleteAValue.textColor = [self.teamColor findTeamColor];
                cell.athleteBValue.textColor = [UIColor blackColor];
            } else if (allSkillsValueB > allSkillsValueA) {
                cell.athleteBValue.textColor = [self.teamColor findTeamColor];
                cell.athleteAValue.textColor = [UIColor blackColor];
            } else {
                cell.athleteAValue.textColor = [UIColor blackColor];
                cell.athleteBValue.textColor = [UIColor blackColor];
            }
            return cell;
        } else {
            static NSString *cellIDStats = @"compareStats";
            VANCompareStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStats];
            
            NSDictionary *dic = [self.statLabels objectAtIndex:indexPath.row -1];
            NSString *value = [dic valueForKey:kValue];
            cell.athleteStat.text = value;
            id valueA = [self searchAthlete:self.athleteA forStat:dic];
            id valueB = [self searchAthlete:self.athleteB forStat:dic];
            if (self.athleteA && valueA) {
                cell.athleteAValue.text = [NSString stringWithFormat:@"%@", valueA];
            } else {
                cell.athleteAValue.text = @"NA";
            }
            if (self.athleteB && valueB) {
                cell.athleteBValue.text = [NSString stringWithFormat:@"%@", valueB];
            } else {
                cell.athleteBValue.text = @"NA";
            }
            NSLog(@"%@ : %@", valueA, valueB);
            if (valueA > valueB) {
                NSLog(@"A is larger than B");
                cell.athleteAValue.textColor = [self.teamColor findTeamColor];
                cell.athleteBValue.textColor = [UIColor blackColor];
            } else if (valueB > valueA) {
                NSLog(@"B is larger than A");
                cell.athleteBValue.textColor = [self.teamColor findTeamColor];
                cell.athleteAValue.textColor = [UIColor blackColor];
            } else {
                NSLog(@"A == B");
                cell.athleteAValue.textColor = [UIColor blackColor];
                cell.athleteBValue.textColor = [UIColor blackColor];
            }
            return cell;
        }
    } else {
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 159;
        } else {
            return 30;
        }
    } else if (indexPath.section == 2)  {
        return 100;
    } else {
        return 50;
    }
}

#pragma mark - Scroll View Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastContentOffset > scrollView.contentOffset.x) {

    } else {
        
    }
}

#pragma mark - Custom Built Methods

- (IBAction)changeAthlete:(id)sender {
    UIButton *button = sender;
    if (button.tag == 1) {
        self.changeAthlete = 1;
    } else {
        self.changeAthlete = 2;
    }
    [self performSegueWithIdentifier:@"toChangeAthlete" sender:self.event];
}

-(void)completeChangeAthlete:(Athlete *)athlete {
    if (self.changeAthlete == 1) {
        self.athleteA = athlete;
    } else {
        self.athleteB = athlete;
    }
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toChangeAthlete"]) {
        VANAthleteListViewController *controller = segue.destinationViewController;
        controller.compareDelegate = self;
        controller.event = sender;
    }
}


@end
