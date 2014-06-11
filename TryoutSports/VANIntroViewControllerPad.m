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

@interface VANIntroViewControllerPad ()

@property (nonatomic) BOOL newLoad;

@end

@implementation VANIntroViewControllerPad

-(void)viewDidLoad {
    [super viewDidLoad];
    self.newLoad = YES;
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Existing Events";
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
    } else {
        [super prepareForSegue:segue sender:sender];
   }
}

@end
