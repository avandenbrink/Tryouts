//
//  VANAthleteDetailTable.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 10/28/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteDetailTable.h"
#import "VANAthleteProfileCell.h"
#import "VANAthleteEditController.h"
#import "NewTableConfiguration.h"
#import "VANTextFieldCell.h"
#import "VANValueSliderCell.h"
#import "VANCollectionCell.h"
#import "VANPickerCell.h"
#import "VANScrollViewTeamSelectionCell.h"
#import "AthleteSkills.h"
#import "AthleteTest.h"
#import "AthleteTags.h"
#import "Image.h"
#import "Event.h"
#import "VANPictureTaker.h"
#import "VANSoloImageViewer.h"
#import "VANAthleteListControllerPad.h"

static int kInsetTopDetailTable = 104.0f;
static int kBottomInset = 64.0f;

@interface VANAthleteDetailTable ()

@property (strong, nonatomic) NewTableConfiguration *config;
@property (strong, nonatomic) VANPictureTaker *pictureTaker;
@property (strong, nonatomic) VANSoloImageViewer *darkView;

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger rowWidth;
@property (nonatomic) NSInteger itemsInRow;
@property (nonatomic) NSArray *cellsDataStrings;

@end

@implementation VANAthleteDetailTable

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kBottomInset, 0);
}


#pragma mark - Table View Data Source Methods

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        // -------- Top Section
        if ([indexPath row] == 0) {
            return [self setupAthleteInfoCellinTable:tableView forIndex:indexPath]; // -------- Athlete Info Cell
        } else if ([indexPath row] == 1) {
            return [self setupProfileImageCellinTable:tableView forIndex:indexPath]; // -------- Athlete Profile Image Cell
        } else if ([indexPath row] == 2){
            return [self setupCellforTeamNumberInTable:tableView forindex:indexPath]; // -------- Athlete Team Number Cell ------------
        } else if ([indexPath row] == 3){
            UITableViewCell *cell = [self.config buildCellInTable:self ForIndex:indexPath withLabel:@"Position" andValue:self.athlete.position]; // -------- Athlete Position Selection Cell
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            return cell;
        } else {
            if (self.config.rowThree) {
                UITableViewCell *cell = [self.config buildPickerCellInTable:self ForIndex:indexPath withValues:[self.event.positions allObjects] andSelected:self.athlete.position forPurpose:@"Position"];
                cell.backgroundColor = [UIColor lightGrayColor];
                return cell;
            } else {
                return nil;
            }
        }
        
    } else if ([indexPath section] == 1) {
        
        // -------- Athelte Tags Cell
        return [self setupTagCellforTable:tableView forIndex:indexPath];
        
    } else if ([indexPath section] == 2) {
        
        // -------- Athlete Skills Cell(s)
        return [self setupSkillsCellforTable:tableView forIndex:indexPath];
        
    } else {
        
        // -------- Athlete Test Cell(s)
        return [self setupTestsCellForTable:tableView forIndex:indexPath];

    }
}

-(void)reloadData {
    [super reloadData];
    
    NSLog(@"Reloading Detail Table Data");
}

#pragma mark - Cell For Row At Support Methods


-(UITableViewCell *)setupAthleteInfoCellinTable:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"detail";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"# %@",self.athlete.number];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateStyle:NSDateFormatterLongStyle];
    cell.detailTextLabel.text = [formater stringFromDate:self.athlete.birthday];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(UITableViewCell *)setupProfileImageCellinTable:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Profile";
    VANAthleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANAthleteProfileCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageScrollView.delegate = cell;
        [cell setup];
    }
    cell.delegate = self.frameDelegate; //Set the Cell's Delegate to the View Controller;
    cell.athlete = self.athlete;
    [cell addOrSubtrackViews];
    [cell attachImages];
    return cell;
}

-(UITableViewCell *)setupCellforTeamNumberInTable:(UITableView *)tableView forindex:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Scroll";
    VANScrollViewTeamSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { //Loading Cell from Nib View
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANScrollViewTeamSelectionCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        
        cell.athlete = self.athlete;
        [cell initiate];
    } else {
    cell.athlete = self.athlete;
    cell.pageController.currentPage = [self.athlete.teamSelected integerValue];
    }
    //Add Code to Move scroller to Team #; here so it moves when an athlete is selected;
    //Also Need to find out where to move this when the table dimensions change to account for this, mabye add Table Reload?
    return cell;
}


-(UITableViewCell *)setupTagCellforTable:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tag";
    VANCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANCollectionCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        [cell initiate];
        cell.backgroundColor = [UIColor darkGrayColor];
    }
    cell.athlete = self.athlete;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.athlete.aTags count] < 1) {
        if (!cell.label) {
            cell.label = [[UILabel alloc] init];
            cell.label.textColor = [UIColor whiteColor];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:cell.label];
            NSDictionary *dic = @{@"label": cell.label};
            NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:0 views:dic];
            NSArray *hori = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:0 views:dic];
            [cell.contentView addConstraints:vert];
            [cell.contentView addConstraints:hori];
        }
        cell.label.text = @"Tap here to add Characteristics";
        
    } else {
        cell.label.text = @"";
        cell.label = nil;
    }
    return cell;

}

-(UITableViewCell *)setupSkillsCellforTable:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sliderCell";
    VANValueSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANValueSliderCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.value.textColor = [UIColor whiteColor];
        cell.label.textColor = [UIColor whiteColor];
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
}

-(UITableViewCell *)setupTestsCellForTable:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"textCell";
    VANTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"VANTextEditCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.label.textColor = [UIColor whiteColor];
        cell.textField.textColor = [UIColor whiteColor];
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Insert Value" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        //cell.controller = (VANManagedObjectTableViewController *)self.delegateView;
    }
    NSMutableSet *set = [self.event mutableSetValueForKey:@"tests"];
    NSArray *fullArray = [set allObjects];
    Tests *object = [fullArray objectAtIndex:[indexPath row]];
    cell.label.text = object.descriptor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.textField addTarget:self action:@selector(keyboardResign:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.textField.delegate = cell;
    cell.textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    
    //  cell.controller = self;
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

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self.config didSelectRowAtIndex:indexPath inTableView:tableView forTheme:[UIColor whiteColor]];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            [self.frameDelegate introduceTagsViewWithAnimation:YES];
        }
    } else if (indexPath.section == 3) {
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            return 40;
        } else if ([indexPath row] == 1) {
            //Home Profile Cell
            return 170;
        } else if ([indexPath row] == 2) {
            //Team Selectiong Cell
            return 97;
        } else if ([indexPath row] == 3) {
            //Position Selection Cell
            return 60;
        } else {
            //Positiong Picker Cell
            return 216;
        }
    } else if ([indexPath section] == 1) {
        //Collection Cell for Athlete Tags
        CGFloat floater =[self findNumberOfRowswithMaxWidth:self.frame.size.width - 18 withStringMargin:10 cellSpacing:10 andFont:[UIFont systemFontOfSize:17]];
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
        if (tag.attribute == nil) {
            [strings addObject:@""];
        } else {
            [strings addObject:tag.attribute];
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

#pragma mark - Custom Methods

-(void)readjustTeamCellWithAnimation:(BOOL)animate
{
    VANScrollViewTeamSelectionCell *cell = (VANScrollViewTeamSelectionCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell setTeamPageForAthlete:self.athlete];
}

-(void)editAthleteProfile:(id)sender {
    
}

-(void)removeImagefromCell:(Image *)image {
    
}

-(void)back {
    
}
/*
- (IBAction)addPicture:(id)sender {
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
    }
    self.pictureTaker.controller = self;
    [self.pictureTaker callImagePickerController];
}*/

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
    [VANGlobalMethods saveManagedObject:self.athlete];
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
    [VANGlobalMethods saveManagedObject:self.athlete];
    
    return newAthleteTest;
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

-(void)buildFullScreenImageViewWithImage {
/*    [self setContentOffset:CGPointMake(0, -63)];
    self.scrollEnabled = NO;
    
    VANAthleteProfileCell *cell = (VANAthleteProfileCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    CGPoint offset = cell.imageScrollView.contentOffset;
    CGFloat imageNumber = offset.x/cell.imageScrollView.frame.size.width;
    NSArray *images = [self.athlete.headShotImage allObjects];
    Image *headshot = [images objectAtIndex:imageNumber];
    
    CGRect viewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y-63, self.frame.size.width, self.frame.size.height);
    if (!self.darkView) {
        self.darkView = [[VANSoloImageViewer alloc] initWithFrame:viewFrame andImage:headshot];
        [self addSubview:self.darkView];
        self.darkView.delegate = self;
    } else {
        NSMutableArray *subviews = [self.subviews mutableCopy];
        if (![[subviews objectAtIndex:[subviews count]-1] isKindOfClass:[VANSoloImageViewer class]]) {
            [self bringSubviewToFront:self.darkView];
        }
        [self.darkView animateInImageViewerWithImage:headshot];
    }*/
}

-(void)updateAthleteTagsCell
{
    VANCollectionCell *cell = (VANCollectionCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.collectionView reloadData];
}


@end
