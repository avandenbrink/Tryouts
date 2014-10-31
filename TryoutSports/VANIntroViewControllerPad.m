//
//  VANIntroViewControllerPAD.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewControllerPad.h"
#import "VANSettingTabsControllerPad.h"

static NSInteger logoWidth = 300;
static NSInteger tableWidth = 400;
static NSInteger tableHeight = 400;
static NSInteger marginSpacing = 100;

static NSString* const fileNameType = @".tryoutsports";
static NSString* const managedObjectEvent = @"Event";

@interface VANIntroViewControllerPad ()

@property (nonatomic) BOOL newLoad; //For Intro Animation

@end

@implementation VANIntroViewControllerPad

@synthesize fileList = _fileList;

- (NSURL*)containerURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [[NSFileManager defaultManager]
               URLForUbiquityContainerIdentifier:nil];
    });
    return url;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.newLoad = YES; //To initiate intro animation
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews {
    if (self.newLoad) {
        CGRect startFromTableFrame = CGRectMake(0,0,0,0);
        CGRect startLogoFrame = CGRectMake(0,0,0,0);
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {

            
            startFromTableFrame = CGRectMake(self.view.frame.size.width, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            startFromTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        }
        [self.eventsTable setFrame:startFromTableFrame];
        [self.logoImage setFrame:startLogoFrame];
    } else {
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            
            
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.newLoad) {
    //Animate the TableView into view. Simlar to the Dropbox Intro
    [UIView animateWithDuration:1 animations:^{
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
        self.newLoad = NO;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect toTableFrame = CGRectMake(0,0,0,0);
    CGRect toLogoFrame = CGRectMake(0,0,0,0);
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
        toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth, logoWidth);
    } else {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
        toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
    }
    [UIView animateWithDuration:1 animations:^{
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAppSettings"]) {
        VANFullNavigationViewController *controller = [segue destinationViewController];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        VANAppSettingsViewController *settingsController = (VANAppSettingsViewController *)[controller topViewController];
        settingsController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"toEventSettings"]) {
        VANFullNavigationViewController *nav = [segue destinationViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        VANSettingTabsControllerPad *tabBarController = (VANSettingTabsControllerPad *)[nav topViewController];
        tabBarController.delegate = tabBarController;
        tabBarController.event = sender;
        tabBarController.selectedIndex = 0;
        VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
        controller.event = tabBarController.event;
        
    } else if ([segue.identifier isEqualToString:@"toNewEvent"]) {
        UINavigationController *nav = [segue destinationViewController];
        UIPageViewController *controller = (UIPageViewController *)[nav topViewController];
        self.interview = [[VANNewEventInterview alloc] init];
        self.interview.delegate = self;
        self.interview.pager = controller;
        controller.delegate = self.interview;
        [self.interview initiateInterview];
        
        
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - Table View Data Source Methods 

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.fileList count] > 0) {
        return @"Existing Events";
    } else {
        return nil;
    }
}

#pragma mark - Popover View Controller Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

#pragma mark - Create New File


-(void)completeNewEventCreationWithEvent:(Event *)event {
    [self performSegueWithIdentifier:@"pushToMain" sender:event];
}

-(void)addEvent:(id)sender
{
    [self performSegueWithIdentifier:@"toNewEvent" sender:nil];
}

-(void)completeNewEventCreationWithEvent:(Event *)event inDocument:(VANTryoutDocument *)document {
    [self performSegueWithIdentifier:@"pushToMain" sender:@[event, document]];
}

#pragma mark - New Event Interview Delegate Methods

-(void)closeInterview {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStoryboard *)getStoryboard {
    return self.navigationController.storyboard;
}

-(void)buildNewEventWithData:(VANNewEventData *)data {
    [self createNewFileWithName:data.eventName];
    
}

@end
