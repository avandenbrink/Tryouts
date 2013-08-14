//
//  VANMainMenuViewControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMainMenuViewControllerPad.h"
#import "VANAthleteDetailControllerPad.h"

@interface VANMainMenuViewControllerPad ()

@end

@implementation VANMainMenuViewControllerPad

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewAthletes"]) {
        UINavigationController *nav = [segue destinationViewController];
        UISplitViewController *split = (UISplitViewController *)[nav topViewController];
        UINavigationController *nav1 = [split.viewControllers objectAtIndex:0];
        VANAthleteListViewController *controller = (VANAthleteListViewController *)[nav1 topViewController];
        controller.event = self.event;
        UINavigationController *nav2 = [split.viewControllers objectAtIndex:1];
        VANAthleteDetailControllerPad *detailController = (VANAthleteDetailControllerPad *)[nav2 topViewController];
        detailController.delegate = self;
        detailController.event = self.event;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)releaseAthleteDetailViews {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
