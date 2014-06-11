//
//  VANDecisionRoomViewControllerPad.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/19/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDecisionRoomViewControllerPad.h"
#import "VANCompareController.h"

@interface VANDecisionRoomViewControllerPad ()

@end

@implementation VANDecisionRoomViewControllerPad

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)compareAthletes:(id)sender
{
    [self performSegueWithIdentifier:@"toCompareController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCompareController"]) {
        VANCompareController *controller = segue.destinationViewController;
        controller.event = self.event;
    }
}

@end
