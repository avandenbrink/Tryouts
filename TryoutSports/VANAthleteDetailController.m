//
//  VANAthleteDetailController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteDetailController.h"
#import "VANAthleteProfileCell.h"
#import "NewTableConfiguration.h"
#import "VANTextFieldCell.h"
#import "VANValueSliderCell.h"
#import "VANCollectionCell.h"
#import "VANPickerCell.h"
#import "VANScrollViewTeamSelectionCell.h"
#import "AthleteSkills.h"
#import "AthleteTest.h"
#import "AthleteTags.h"
#import "VANTagsTableViewController.h"
#import "Image.h"
#import "VANPictureTaker.h"



@interface VANAthleteDetailController ()

@property (strong, nonatomic) NewTableConfiguration *config;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@property (strong, nonatomic) VANPictureTaker *pictureTaker;
//@property (strong, nonatomic) UIPickerView *pickerView;
//@property (nonatomic) BOOL rowThree;

-(AthleteSkills *)compareSkillAndValueforSkill:(Skills *)object inArray:(NSArray *)array;
-(AthleteTest *)compareTestAndValueforTest:(Tests *)object inArray:(NSArray *)array;

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger rowWidth;
@property (nonatomic) NSInteger itemsInRow;
@property (nonatomic) NSArray *cellsDataStrings;

@end

@implementation VANAthleteDetailController

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.config = [[NewTableConfiguration alloc] init];
    self.config.controller = self;
	// Do any additional setup after loading the view.
    self.navigationItem.title = self.athlete.name;
    self.tableview.backgroundColor = [UIColor darkGrayColor];
    self.backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    //Temporary Code
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    VANCollectionCell *cell = (VANCollectionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    [cell.collectionView reloadData];
    [self.tableView reloadData];
    if ([self.athlete.aTags count] > 0) {
        cell.label.text = @"";
    }
}

-(void)viewDidAppear:(BOOL)animated {
 /*   VANCollectionCell *cell = (VANCollectionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    CGFloat floater = [self findNumberOfRowswithMaxWidth:self.view.frame.size.width - 18 withStringMargin:10 cellSpacing:10 andFont:[UIFont systemFontOfSize:17]];
    [cell.collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, floater)];
    NSLog(@"%f",cell.contentView.frame.size.height);
    NSLog(@"%f",cell.collectionView.frame.size.height);*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    [self cleanUpExcessSkillsAndTests];
    
    [self saveManagedObjectContext:self.event];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cleanUpExcessSkillsAndTests {
    NSMutableArray *athleteSkillsArray = (NSMutableArray *)[self.athlete.skills allObjects];
    NSMutableArray *eventSkillsArray = (NSMutableArray *)[self.event.skills allObjects];
    if ([athleteSkillsArray count] > [eventSkillsArray count]) {
        for (AthleteSkills *aSkill in athleteSkillsArray) {
            BOOL exists = [self deleteUnusedSkills:aSkill inSkills:eventSkillsArray];
            if (!exists) {
                [[self.event managedObjectContext] deleteObject:aSkill];
            }
        }
    }
    NSMutableArray *athleteTestArray = (NSMutableArray *)[self.athlete.tests allObjects];
    NSMutableArray *eventTestArray = (NSMutableArray *)[self.event.tests allObjects];
    if ([athleteTestArray count] > [eventTestArray count]) {
        for (AthleteTest *aTest in athleteTestArray) {
            BOOL exists = [self deleteUnusedTests:aTest inTests:eventTestArray];
            if (!exists) {
                [[self.athlete managedObjectContext] deleteObject:aTest];
            }
        }
    }
}

-(BOOL)deleteUnusedSkills:(AthleteSkills *)skill inSkills:(NSMutableArray *)skills {
    for (Skills *eSkill in skills) {
        if ([eSkill.descriptor isEqualToString:skill.attribute]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)deleteUnusedTests:(AthleteTest *)test inTests:(NSMutableArray *)tests {
    for (Tests *eTest in tests) {
        if ([eTest.descriptor isEqualToString:test.attribute]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.athlete == nil) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    } else {
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (!self.config.rowThree) {
            return 4;
        } else {
            return 5;
        }
    } else if (section == 1) {
        return 1;
    } else if (section == 2){
        return [self.event.skills count];
    } else {
        return [self.event.tests count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        // -------- Top Section
        if ([indexPath row] == 0) {
            static NSString *CellIdentifier = @"detail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"# %@",self.athlete.number];
            cell.detailTextLabel.text = [__dateFormatter stringFromDate:self.athlete.birthday];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else if ([indexPath row] == 1) {
            // -------- Athlete Information Cell
            static NSString *CellIdentifier = @"Profile";
            VANAthleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.athlete.headShotImage count] > 0) {
                Image *imageMO = [[self.athlete.headShotImage allObjects] objectAtIndex:0];
                UIImage *image = [UIImage imageWithData:imageMO.headShot];
                cell.pic.image = image;
                cell.pic.contentMode = UIViewContentModeScaleAspectFit;
            } else if ([self.athlete.headShotImage count] == 1) {
                UIImage *cameraImage = [UIImage imageNamed:@"cameraButton.png"];
                cell.pic.image = cameraImage;
                cell.pic.contentMode = UIViewContentModeScaleAspectFit;
            } else {
                NSArray *array = [self.athlete.headShotImage allObjects];
                NSMutableArray *images = nil;
                for (NSInteger i = 0; i < [array count]; i++) {
                    Image *imageData = [array objectAtIndex:i];
                    UIImage *image = [UIImage imageWithData:imageData.headShot];
                    [images addObject:image];
                }
                cell.pic.animationImages = images;
            }
            return cell;
        } else if ([indexPath row] == 2){
            // -------- Athlete Team Number Cell ------------ //
            static NSString *CellIdentifier = @"Scroll";
            VANScrollViewTeamSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if ([self.event.numTeams integerValue] < 2) {
                NSLog(@"WARNING: TeamsCell (%@) disrupted because event.numTeams is less than 1, Replacing it with 1 again", self.event.numTeams);
                self.event.numTeams = [NSNumber numberWithInteger:2];
            }
            cell.athlete = self.athlete;
            cell.scrollViewer.contentSize = CGSizeMake(self.view.frame.size.width*[self.event.numTeams integerValue], cell.scrollViewer.frame.size.height);
            cell.pageController.numberOfPages = [self.event.numTeams integerValue];
            [cell initiate];
            
            if ([cell.scrollViewer.subviews count] < [self.event.numTeams integerValue]) {
                for (int i = 0 ; i < [self.event.numTeams intValue]; i++) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width  *i, 6, self.view.frame.size.width, 48)];
                    [view setTranslatesAutoresizingMaskIntoConstraints:NO];                        
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    if (i == 0) {
                        label.text = @"No Team Selected";
                        view.backgroundColor = [UIColor darkGrayColor];
                    } else {
                        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
                        view.backgroundColor = [teamColor findTeamColor];
                        label.text = [NSString stringWithFormat:@"Team %d", i];
                    }
                    [view addSubview:label];
                    [cell.scrollViewer addSubview:view];
                    
                    /*
                    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.scrollViewer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
                    [cell.scrollViewer addConstraint:contraint];
                    contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.scrollViewer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
                    [cell.scrollViewer addConstraint:contraint];*/
                }
            }
            
            return cell;
            
        } else if ([indexPath row] == 3){
            // -------- Athlete Position Selection Cell
            return [self.config buildCellInTable:tableView ForIndex:indexPath withLabel:@"Position" andValue:self.athlete.position];            
        } else {
            if (self.config.rowThree) {
                return [self.config buildPickerCellInTable:tableView ForIndex:indexPath withValues:[self.event.positions allObjects] forPurpose:@"Position"];
            } else {
                return nil;
            }
        }
        
    } else if ([indexPath section] == 1) {
        // -------- Athelte Tags Cell
        static NSString *CellIdentifier = @"Tags";
        VANCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell = [cell init];

        cell.athlete = self.athlete;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.athlete.aTags count] < 1) {
            cell.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            cell.label.text = @"Tap here to add tags";
            cell.label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:cell.label];
        }
        return cell;
        
    } else if ([indexPath section] == 2) {
        // -------- Athlete Skills Cell(s)
        static NSString *CellIdentifier = @"sliderCell";
        VANValueSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANValueSliderCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
        NSMutableSet *set = [self.event mutableSetValueForKey:@"skills"];
        NSArray *fullArray = [set allObjects];
        Skills *object = [fullArray objectAtIndex:[indexPath row]];
        cell.label.text = object.descriptor;
        cell.slider.minimumValue = 0;
        cell.slider.maximumValue = 5;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        cell.sideColor.backgroundColor = [teamColor findTeamColor];
        
        AthleteSkills *aSkill = [self compareSkillAndValueforSkill:object inArray:[self.athlete.skills allObjects]];
            if (aSkill != nil) {
                cell.slider.value = [aSkill.value floatValue];
                cell.skill = aSkill;
                cell.value.text = [NSString stringWithFormat:@"%.00f", [aSkill.value floatValue]];

            } else {
                AthleteSkills *newValue = [self addNewAthleteSkillRelationship];
                cell.slider.value = 2.5;
                cell.skill = newValue;
                newValue.value = [NSNumber numberWithFloat:cell.slider.value];
                cell.value.text = @"2.5";
                newValue.attribute = object.descriptor;
        }
        
        return cell;
        
    } else {
        
        // -------- Athlete Test Cell(s)
        static NSString *CellIdentifier = @"textCell";
        VANTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANTextEditCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
        NSMutableSet *set = [self.event mutableSetValueForKey:@"tests"];
        NSArray *fullArray = [set allObjects];
        Tests *object = [fullArray objectAtIndex:[indexPath row]];
        cell.label.text = object.descriptor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        cell.sideView.backgroundColor = [teamColor findTeamColor];
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.textField addTarget:self action:@selector(keyboardResign:) forControlEvents:UIControlEventEditingDidEndOnExit];
        cell.textField.delegate = cell;
        cell.textField.keyboardAppearance = UIKeyboardAppearanceDefault;

        cell.textField.placeholder = @"Insert Value";
        cell.controller = self;
        AthleteTest *aTest = [self compareTestAndValueforTest:object inArray:[self.athlete.tests allObjects]];
        if (aTest != nil) {
            cell.textField.text = aTest.value;
            cell.test = aTest;
        } else {
            AthleteTest *newTest = [self addNewAthleteTestRelationship];
            newTest.attribute = cell.label.text;
            cell.test = newTest;
        }
        return cell;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self saveManagedObjectContext:self.athlete];
}

#pragma mark - Custom Built Methods

- (IBAction)addPicture:(id)sender {
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
    }
    self.pictureTaker.controller = self;
    [self.pictureTaker callImagePickerController];
}

-(IBAction)keyboardResign:(id)sender {
    [sender resignFirstResponder];
}

-(AthleteSkills *)compareSkillAndValueforSkill:(Skills *)object inArray:(NSArray *)array {
    for (AthleteSkills *skill in array) {
        NSString *attribute = skill.attribute;
        NSString *value = object.descriptor;
        if ([attribute isEqualToString:value]) {
            return skill;
        }
    }
    return nil;
}

-(AthleteTest *)compareTestAndValueforTest:(Tests *)object inArray:(NSArray *)array {

    for (AthleteTest *test in array) {
        
        NSString *attribute = test.attribute;
        NSString *value = object.descriptor;
        if ([attribute isEqualToString:value]) {
            return test;
        }
    }
    return nil;
    
}

-(AthleteSkills *)addNewAthleteSkillRelationship {
    NSMutableSet *relationshipSet = [self.athlete mutableSetValueForKey:@"skills"];
    NSLog(@"Adding New Skill, athleteDetailController.m - addNewAthleteSkillRelationship");
    NSEntityDescription *entity = [self.athlete entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:@"skills"];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];

    AthleteSkills *newAthleteSkill = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:[self.athlete managedObjectContext]];
    [relationshipSet addObject:newAthleteSkill];
    [self saveManagedObjectContext:self.athlete];
    return newAthleteSkill;
}

-(AthleteTest *)addNewAthleteTestRelationship {
    NSMutableSet *relationshipSet = [self.athlete mutableSetValueForKey:@"tests"];
    NSLog(@"Adding New Test, athleteDetailController.m - addNewAthleteTestRelationship");
    NSEntityDescription *entity = [self.athlete entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:@"tests"];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    AthleteTest *newAthleteTest = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:[self.athlete managedObjectContext]];
    [relationshipSet addObject:newAthleteTest];
    [self saveManagedObjectContext:self.athlete];
    
    return newAthleteTest;
    
}

#pragma mark - Table View Delegate Methods



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            return 40;
        } else if ([indexPath row] == 1) {
            //Home Profile Cell
            if ([self.athlete.headShotImage count] > 0) {
                return 170;
            } else {
                return 40;
            }
        } else if ([indexPath row] == 2) {
            //Team Selectiong Cell
            return 90;
        } else if ([indexPath row] == 3) {
            //Position Selection Cell
            return 60;
        } else {
            //Positiong Picker Cell
            return 216;
        }
    } else if ([indexPath section] == 1) {
        //Collection Cell for Athlete Tags
        CGFloat floater =[self findNumberOfRowswithMaxWidth:self.view.frame.size.width - 18 withStringMargin:10 cellSpacing:10 andFont:[UIFont systemFontOfSize:17]];
        return floater;
    } else if ([indexPath section] == 2){
        //Skills Cell
        return 70;
    } else {
        //Tests Cell
        return 60;
    }
}

-(CGFloat)findNumberOfRowswithMaxWidth:(NSInteger)width withStringMargin:(NSInteger)margin cellSpacing:(NSInteger)spacing andFont:(UIFont *)font {
    
    NSMutableArray *strings = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.athlete.aTags count]; i++) {
        AthleteTags *tag = [[self.athlete.aTags allObjects] objectAtIndex:i];
        if (tag.descriptor == nil) {
            [strings addObject:@""];
        } else {
            [strings addObject:tag.descriptor];
        }
    }
    
    self.rows = 0;
    self.rowWidth = 0;
    self.itemsInRow = 0;
    
    for (NSString *string in strings) {
        self.itemsInRow++;
        CGSize stringSize = [string sizeWithAttributes:[NSDictionary dictionaryWithObjects:@[font] forKeys:@[NSFontAttributeName]]];
//        NSLog(@"String: %@ has width: %f", string, stringSize.width);
        self.rowWidth += stringSize.width + (margin * 2);
        if (self.itemsInRow != 1) {
//            NSLog(@"Adding extra %ld", (long)spacing);
            self.rowWidth += spacing;
        }
 //       NSLog(@"Current Row Length: %ld", (long)self.rowWidth);
        if (self.rowWidth > width) {
//            NSLog(@"    Adding Row because %ld is larger than %ld", (long)self.rowWidth, (long)width);
            self.rows++;
            self.rowWidth = stringSize.width + (margin * 2);
            self.itemsInRow = 1;
        }
    }
    self.rows++; //Add One extra Row for the last still that stuck in the formula (Doesn't register +1 if it doesn't reach end of the line
    //CGSize viewSize = CGSizeMake(collectionView.frame.size.width, (self.rows * 40) + ((self.rows - 1) * 10) + 20);
    CGFloat floater = (self.rows * 30) + ((self.rows - 1) * 9) + 16;
    return floater;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 26;
    } else {
     return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    view.backgroundColor = [UIColor darkGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    if (section == 1) {
        titleLabel.text = @"Character Traits";
    } else if (section == 2) {
        titleLabel.text = @"Skills";
    } else if (section == 3){
        titleLabel.text = @"Tests";
    }
    [view addSubview:titleLabel];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self.config didSelectRowAtIndex:indexPath inTableView:tableView];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"pushToTags" sender:nil];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToTags"]) {
        VANTagsTableViewController *controller = segue.destinationViewController;
        controller.event = self.event;
        controller.athlete = self.athlete;
    }
}

/* 
 // Decided against Using this Setup: Opted for a new view Controller with Collection view within it.
 
-(IBAction)openPopup {
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"popoverView"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.controller];
    self.controller.athlete = self.athlete;
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:CGRectMake(self.cell.frame.origin.x, self.cell.frame.origin.y, self.cell.frame.size.width - 200, self.cell.frame.size.height - 115) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}
*/

@end
