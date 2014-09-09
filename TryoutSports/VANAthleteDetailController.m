//
//  VANAthleteDetailController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteDetailController.h"
#import "VANAthleteEditController.h"
#import "VANTagsTableViewController.h"

#import "VANAthleteProfileCell.h"
#import "VANTextFieldCell.h"
#import "VANValueSliderCell.h"
#import "VANCollectionCell.h"
#import "VANPickerCell.h"
#import "VANScrollViewTeamSelectionCell.h"

#import "NewTableConfiguration.h"
#import "VANDetailTableDelegate.h"

#import "AthleteSkills.h"
#import "AthleteTest.h"
#import "AthleteTags.h"
#import "Image.h"


@interface VANAthleteDetailController ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) VANDetailTableDelegate *tableDelegate;
@property (strong, nonatomic) VANPictureTaker *pictureTaker;

//Objects for the Solo Image Viewer
@property (strong, nonatomic) VANSoloImageViewer *imageDisplay;

-(AthleteSkills *)compareSkillAndValueforSkill:(Skills *)object inArray:(NSArray *)array;
-(AthleteTest *)compareTestAndValueforTest:(Tests *)object inArray:(NSArray *)array;

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger rowWidth;
@property (nonatomic) NSInteger itemsInRow;
@property (nonatomic) NSArray *cellsDataStrings;

@end

@implementation VANAthleteDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create our Delegate and DataSource Object
    self.tableDelegate = [[VANDetailTableDelegate alloc] initWithTableView:self.tableView];
    self.tableDelegate.delegate = self;
    self.tableDelegate.event = self.event;
    [self.tableDelegate resetAthletesPointertoAthlete:self.athlete];
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = self.athlete.name;
    self.backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    //Any Temporary Code....
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [_tableDelegate updateAthleteTagsCellWithAthlete:self.athlete andReloadCell:NO];
    self.navigationItem.title = self.athlete.name;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tableDelegate moveTeamScrollViewWithAnimation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.imageDisplay = nil;
}

#pragma mark - VAN Image Picker Delegate Methods


-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passBackSelectedImageData:(NSData *)imageData
{
    //VANAthleteProfileCell *cell =  (VANAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    // --- [cell addNewImageFromData:imageData];  --- was used to animate image into place but not currently functioning
    
    //B. Create a new Image object and attach it to our selected athlete.
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    
    Image *newImage = (Image *)[methods addNewRelationship:@"images" toManagedObject:self.athlete andSave:NO];
    newImage.headShot = imageData;
    if ([self.athlete.images count] == 1) {
        self.athlete.profileImage = newImage;
    }
    [self.tableView reloadData];
    
    [self saveManagedObjectContext:self.athlete];
}

#pragma mark - VAN Solo Image View Delegate Methods

-(void)deleteImagefromSoloImageViewer:(Image *)image
{

}

-(void)closeSoloImageViewer
{
    self.tableView.scrollEnabled = YES;
    [self saveManagedObjectContext:self.athlete];
}

-(void)requiresUIUpdating
{
    [self.tableView reloadData];
    VANAthleteListViewController *controller = (VANAthleteListViewController *)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    NSString *string = self.athlete.name;
    [controller removeImagesFromProfileCache:@[string]];
  //  controller.shouldReloadCache = YES;
}

#pragma mark - Image Full Screen Methods

-(void)buildFullScreenImageViewWithImage
{
    
}

-(void)removeImagefromCell:(Image *)image
{
    VANAthleteProfileCell *cell = (VANAthleteProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CGSize oldSize = cell.imageScrollView.contentSize;
    CGSize newSize = CGSizeMake(oldSize.width-cell.imageScrollView.frame.size.width, oldSize.height);
    [cell.imageScrollView setContentSize:newSize];
    
    NSInteger imageInArray;
    NSArray *images = [self.athlete.images allObjects];
    for (NSInteger i = 0; i < [images count]; i++) {
        Image *potentialImage = [images objectAtIndex:i];
        if (potentialImage == image) {
            imageInArray = i;
        }
    }
    NSLog(@"Array Number: %lu", (long)imageInArray);
    NSArray *subviews = [cell.imageScrollView subviews];
    for (NSInteger x = 0; x < [subviews count]; x++) {
        UIView *view = [subviews objectAtIndex:x];
        if (x > (imageInArray*2)+1) {
            CGRect old = view.frame;
            CGRect new = CGRectMake(old.origin.x-cell.imageScrollView.frame.size.width, old.origin.y, old.size.width, old.size.height);
            [view setFrame:new];
            NSLog(@"Moving: %lu: View: %@", (long)x, [view description]);
        } else if (x == imageInArray*2 || x == (imageInArray*2)+1) {
            [view removeFromSuperview];
            NSLog(@"Removing: %lu: View: %@", (long)x, [view description]);
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Button Pressed Methods

- (void)addPicture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!self.pictureTaker) {
            self.pictureTaker = [[VANPictureTaker alloc] init];
        }
        self.pictureTaker.delegate = self;
        [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
    } else {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"No Camera was Detected" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
        action.tag = 1;
        [action showInView:self.view];
    }
}

-(IBAction)keyboardResign:(id)sender
{
    [sender resignFirstResponder];
}

-(void)back
{
    [self cleanUpExcessSkillsAndTests]; //Clean up Any possible issues with the Athlete Data
    [self saveManagedObjectContext:self.athlete]; //Save Athletes Profile
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editAthleteProfile:(id)sender {
    [self performSegueWithIdentifier:@"editAthlete" sender:self.athlete];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToTags"]) {
        VANTagsTableViewController *controller = segue.destinationViewController;
        controller.event = self.event;
        controller.athlete = self.athlete;
    } else if ([segue.identifier isEqualToString:@"editAthlete"]) {
        VANAthleteEditController *controller = segue.destinationViewController;
        controller.athlete = sender;
        controller.event = self.event;
    }
}

#pragma mark - Core Data Managment Methods

-(void)cleanUpExcessSkillsAndTests
{
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

-(BOOL)deleteUnusedSkills:(AthleteSkills *)skill inSkills:(NSMutableArray *)skills
{
    for (Skills *eSkill in skills) {
        if ([eSkill.descriptor isEqualToString:skill.attribute]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)deleteUnusedTests:(AthleteTest *)test inTests:(NSMutableArray *)tests
{
    for (Tests *eTest in tests) {
        if ([eTest.descriptor isEqualToString:test.attribute]) {
            return YES;
        }
    }
    return NO;
}


-(AthleteSkills *)compareSkillAndValueforSkill:(Skills *)object inArray:(NSArray *)array
{
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

#pragma mark - Scroll View Delegate Methods

-(void)cleanUpImageViewer {
    if (self.imageDisplay.alpha > 0) {
        self.imageDisplay.alpha = 0;
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - Detail Table View Delegate Methods

-(Athlete *)collectAthlete
{
    return self.athlete;
}

-(Event *)collectEvent {
    return self.event;
}

-(void)introduceTagsViewWithAnimation:(BOOL)animate {
    [self performSegueWithIdentifier:@"pushToTags" sender:nil];
}


-(void)VANTableViewCellrequestsImageforAthete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell
{
    self.tableView.scrollEnabled = NO;
    self.tableView.contentOffset = CGPointMake(0, -64);
    
    CGPoint offset = cell.imageScrollView.contentOffset;
    
    CGFloat imageNumber = offset.x/cell.imageScrollView.frame.size.width;
    
    NSArray *images = [self.athlete.images allObjects];
    Image *headshot = [images objectAtIndex:imageNumber];
    
    CGRect viewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-63, self.view.frame.size.width, self.view.frame.size.height);
    if (!self.imageDisplay) {
        self.imageDisplay = [[VANSoloImageViewer alloc] initWithFrame:viewFrame andImage:headshot];
        [self.view addSubview:self.imageDisplay];
        self.imageDisplay.delegate = self;
    } else {
        NSMutableArray *subviews = [self.view.subviews mutableCopy];
        if (![[subviews objectAtIndex:[subviews count]-1] isKindOfClass:[VANSoloImageViewer class]]) {
            [self.view bringSubviewToFront:self.imageDisplay];
        }
    }
    
    CGRect startView = CGRectMake(self.tableView.frame.origin.x+cell.frame.origin.x,
                                  self.view.frame.origin.y-self.view.frame.size.width,
                                  self.tableView.frame.size.width, self.tableView.frame.size.width);
    [self.imageDisplay animateInImageViewerWithImage:headshot andInitialPosition:startView];

    
}

-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Take Picture" otherButtonTitles:@"Select from Library", nil];
    action.tag = 0; //First Tag for Picture Option
    [action showInView:self.view];
}

-(void)adjustContentInsetsForEditing:(BOOL)editing {
    //Don't need to do Anything here becuase it is a tableView Controller that Controls itself
}

-(void)addTextFieldContent:(NSString *)string ToContextForTitle:(NSString *)title {
    
}

#pragma mark - Action Sheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) { //Picture or Library Option
        if (buttonIndex == 0) {
            [self addPicture];
        }
    } else if (actionSheet.tag == 1) {

    }
    
}

@end
