//
//  VANNewEventInterview.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-21.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANNewEventInterview.h"
#import "VANTeamColor.h"

#import "VANEventNameController.h"
#import "VANSimpleTableViewController.h"


//Clases for Custom Table Views
#import "VANTeamDelegate.h"
#import "VANAthleteAddObject.h"
#import "VANPositionsDelegate.h"
#import "VANSkillsDelegate.h"
#import "VANTestsDelegate.h"
#import "VANCreateSuccessController.h"


NSInteger pageCount = 6;

@interface VANNewEventInterview ()

@property (strong, nonatomic) UIPageControl *pageController;
@property (strong, nonatomic) UILabel *stepsLabel;
@property (nonatomic) NSInteger step;
@property (strong, nonatomic) NSMutableArray *controllers;
@property (strong, nonatomic) UIBarButtonItem *back;
@property (strong, nonatomic) UIBarButtonItem *forward;

//View Controllers
@property (strong, nonatomic) VANEventNameController *name;

@end

@implementation VANNewEventInterview

-(void)initiateInterview
{
    self.pager.view.backgroundColor = [UIColor whiteColor];
    
    //Add Buttons
    self.back = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(stepBack)];
    self.pager.navigationItem.leftBarButtonItem = self.back;
    self.forward = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(stepForward)];
    self.pager.navigationItem.rightBarButtonItem = self.forward;
    
    
    //Build Pager
    self.pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.pager.view.frame.size.height-500, self.pager.view.frame.size.width, 30)];
    self.pageController.numberOfPages = pageCount;
    VANTeamColor *team = [VANTeamColor alloc];
    self.pageController.pageIndicatorTintColor = [team lightColor];
    self.pageController.currentPageIndicatorTintColor = [team findTeamColor];
    [self.pageController setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pager.view addSubview:self.pageController];
    [self.pager.view bringSubviewToFront:self.pageController];
    
    NSDictionary *views = @{@"pager": self.pageController};
    
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[pager]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    [self.pager.view addConstraints:vertical];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pager(30)]-10-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    [self.pager.view addConstraints:horizontal];
    
    self.step = 0;
    
    self.data = [[VANNewEventData alloc] init];
    
    [self stepToFirstController];
}

-(void)addValuestoEventDocument:(Event *)doc {
    //Set Name
    doc.name = self.data.eventName;

    for (NSString *position in self.data.positions) {
        Positions *p = (Positions *)[VANGlobalMethods addNewRelationship:@"positions" toManagedObject:doc andSave:NO];
        p.position = position;
    }
    
    for (NSString *skill in self.data.skills) {
        Skills *s = (Skills *)[VANGlobalMethods addNewRelationship:@"skills" toManagedObject:doc andSave:NO];
        s.descriptor = skill;
    }
    
    for (NSString *test in self.data.tests) {
        Tests *t = (Tests *)[VANGlobalMethods addNewRelationship:@"tests" toManagedObject:doc andSave:NO];
        t.descriptor = test;
    }
    
    for (NSString *team in self.data.teams) {
        TeamName *t = (TeamName *)[VANGlobalMethods addNewRelationship:@"teamNames" toManagedObject:doc andSave:NO];
        t.name = team;
    }
    
    [VANGlobalMethods saveManagedObject:doc];
    VANInterviewController *currentController = [self.controllers objectAtIndex:self.step];
    [currentController successfullyBuiltEvent];
}

#pragma mark - Forward/Back Step Methods

-(void)stepToFirstController {
    UIStoryboard *story = [self.delegate getStoryboard];
    VANEventNameController * nameController = [story instantiateViewControllerWithIdentifier:@"eventNameController"];
    nameController.delegate = self;
    nameController.data = self.data;
    nameController.canSkip = NO;
    
    if (!self.controllers) {
        self.controllers = [NSMutableArray arrayWithObject:nameController];
    }
    nameController.view.backgroundColor = [UIColor whiteColor];
    nameController.instructions.text = @"1. Select the name for this Tryout";
    [self.pager setViewControllers:@[nameController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)stepBack
{
    if (self.step == 0 || !self.step) {
        [self.delegate closeInterview];
        return;
    } else if (self.step == 1) {
        self.back.title = @"Cancel";
    }
    
    self.step--;
    self.pageController.currentPage = self.step;
    
    VANInterviewController *controller = [self.controllers objectAtIndex:self.step];
    
    //Customize View for View Controller
    if (controller.canSkip && !controller.hasBeenTouched) {
        self.forward.title = @"Skip";
    } else {
        self.forward.title = @"Next";
    }
    
    if (!self.pager.navigationItem.rightBarButtonItem) {
        self.pager.navigationItem.rightBarButtonItem = self.forward;
    }
    
    [self.pager setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)stepForward
{
    VANInterviewController *currentController = [self.controllers objectAtIndex:self.step];
    if ([currentController canPrepareToMoveForward]) {
        [currentController prepareToResignSpotlight];
        
        self.step++;
        
        //Find View Controller
        VANInterviewController *controller;
        
        if ([self.controllers count] > self.step) {
            controller = [self.controllers objectAtIndex:self.step];
        } else {
            controller = [self buildViewController];
        }
        
        controller.delegate = self;
        controller.data = self.data;
        

        
        
        if (self.step != 0 || !self.step) {
            self.back.title = @"Back";
        }
        
        self.pageController.currentPage = self.step;
        
        
        [self.pager setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

-(VANInterviewController *)buildViewController {
    
    VANInterviewController *controller;
    
    switch (self.step) {
        case 0:
            NSLog(@"Shouldn't be using this buildmethod in newEventInterview");
            break;
        
        case 1:
            controller = [self buildTeamsViewController];
            break;
            
        case 2:
            controller = [self buildPositionsViewController];
            break;
            
        case 3:
            controller = [self buildSkillsViewController];
            break;
            
        case 4:
            controller = [self buildTestsViewController];
            break;
            
        case 5:
            controller = [self buildAthleteViewController];
            break;
            
        case 6:
            controller = [self buildCreateSuccessController];
            break;
            
        default:
            controller = [[VANInterviewController alloc] init];
            controller.view.backgroundColor = [UIColor goldenYellow];
            break;
    }
    
    if (!self.controllers) {
        self.controllers = [NSMutableArray arrayWithObject:controller];
    } else {
        [self.controllers addObject:controller];
    }
    
    return controller;
}


#pragma mark - Custom Controller Build Methods
-(VANInterviewController *)buildTeamsViewController
{
    VANSimpleTableViewController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"InterviewTableController"];
    controller.delegate = self;
    
    VANTeamDelegate *tableDelegate = [[VANTeamDelegate alloc] init];
    controller.tableDelegate = tableDelegate;
    tableDelegate.data = self.data;
    tableDelegate.delegate = controller;
    
    NSArray *title = @[@"Teams:"];
    NSArray *message = @[@"You will be able to group your athletes based on these positions during and after the tryout"];
    NSString *inst = @"2. Teams: create the teams that you are picking for. Customize their name and other aspects.";
    
    controller.canSkip = YES;
    controller.showAddMore = YES;
    
    controller.elements = @{@"headerTitle": title, @"message": message, @"instructions": inst};
    return controller;
}

-(VANInterviewController *)buildPositionsViewController
{
    VANSimpleTableViewController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"InterviewTableController"];
    controller.delegate = self;
    
    VANPositionsDelegate *tableDelegate = [[VANPositionsDelegate alloc] init];
    controller.tableDelegate = tableDelegate;
    tableDelegate.data = self.data;
    tableDelegate.delegate = controller;
    
    NSArray *title = @[@"Positions:"];
    NSArray *message = @[@"You will be able to group your athletes based on these positions during and after the tryout"];
    NSString *inst = @"2. Add the positions for your sport.";
    
    controller.canSkip = YES;
    controller.showAddMore = YES;
    
    controller.elements = @{@"headerTitle": title, @"message": message, @"instructions": inst};
    return controller;
}

-(VANInterviewController *)buildSkillsViewController
{
    VANSimpleTableViewController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"InterviewTableController"];
    
    VANSkillsDelegate *tableDelegate = [[VANSkillsDelegate alloc] init];
    controller.tableDelegate = tableDelegate;
    tableDelegate.data = self.data;
    tableDelegate.delegate = controller;
    
    NSString *inst = @"3. Add the skills that you would like to judge your athletes by. (eg. Passing)";

    NSArray *message = @[@"Skills are recorded as a value between 1 and 5. You will be able to asses and compare your athletes based on the score you give them."];
    NSArray *title = @[@"Skills:"];
    
    controller.canSkip = YES;
    controller.showAddMore = YES;

    controller.elements = @{@"headerTitle": title, @"message": message, @"instructions": inst};
    return controller;
}

-(VANInterviewController *)buildTestsViewController
{
    VANSimpleTableViewController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"InterviewTableController"];
    VANTestsDelegate *tableDelegate = [[VANTestsDelegate alloc] init];
    controller.tableDelegate = tableDelegate;
    tableDelegate.data = self.data;
    tableDelegate.delegate = controller;
    
    NSString *inst = @"4. Add the tests that you will be using to measure your athletes abilities. (eg. Height)";
    
    NSArray *message = @[@"Tests are recorded as an open text field for any value you need to add. You will be able to input any type of value relating to this test."];
    NSArray *title = @[@"Tests:"];
    
    controller.canSkip = YES;
    controller.showAddMore = YES;

    controller.elements = @{@"headerTitle": title, @"message": message, @"instructions": inst};
    return controller;
}

-(VANSimpleTableViewController *)buildAthleteViewController
{
    VANSimpleTableViewController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"InterviewTableController"];
    VANAthleteAddObject *tableDelegate = [[VANAthleteAddObject alloc] init];
    controller.tableDelegate = tableDelegate;
    tableDelegate.data = self.data;
    tableDelegate.delegate = controller;
    
    NSString *inst = @"5. Add your athletes. There are a number of ways you can do this.";
    
    controller.canSkip = YES;
    
    controller.elements = @{@"instructions": inst};
    return controller;
}

-(VANCreateSuccessController *)buildCreateSuccessController {
    VANCreateSuccessController *controller = [[self.delegate getStoryboard] instantiateViewControllerWithIdentifier:@"SuccessController"];
    controller.isLastView = YES;
    return controller;
}


#pragma mark -VANInterviewController Delegate Methods


-(void)updateForwardButtonToTitle:(NSString *)title isActive:(BOOL)active {
    if (title) {
        self.pager.navigationItem.rightBarButtonItem = self.forward;
        self.forward.title = title;
        self.forward.enabled = active;
    } else {
        self.pager.navigationItem.rightBarButtonItem = nil;
    }

}
-(void)updateBackButtonToTitle:(NSString *)title isActive:(BOOL)active {
    if (title) {
        self.pager.navigationItem.leftBarButtonItem = self.back;
        self.back.title = title;
        self.back.enabled = active;
    } else {
        self.pager.navigationItem.leftBarButtonItem = nil;
    }

}
-(void)requestCloseContainer {
    [self.delegate closeInterview];
}

-(void)requestFileBuild {
    [self.delegate buildNewEventWithData:self.data];
}

@end
