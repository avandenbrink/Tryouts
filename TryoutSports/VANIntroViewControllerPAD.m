//
//  VANIntroViewControllerPAD.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewControllerPad.h"

@interface VANIntroViewControllerPad ()

@end

@implementation VANIntroViewControllerPad

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.eventsTable reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Existing Events";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAppSettings"]) {
        VANFullNavigationViewController *controller = [segue destinationViewController];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        VANAppSettingsViewController *settingsController = (VANAppSettingsViewController *)[controller topViewController];
        settingsController.delegate = self;
    } else {
        [super prepareForSegue:segue sender:sender];
   }
}



@end
