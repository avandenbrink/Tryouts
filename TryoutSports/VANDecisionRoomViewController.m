//
//  VANDecisionRoomViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-12.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDecisionRoomViewController.h"
#import "VANHeadShotController.h"

@interface VANDecisionRoomViewController ()

@end

@implementation VANDecisionRoomViewController

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

- (IBAction)compareAthletes:(id)sender {
    [self performSegueWithIdentifier:@"toAthleteComparison" sender:self.event];
}

- (IBAction)topRankings:(id)sender {
}

-(void)imageCollection:(id)sender {
    [self performSegueWithIdentifier:@"toImages" sender:self.event];
}

- (IBAction)seeSuggestedRankings:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAthleteComparison"]) {
        VANManagedObjectViewController *controller = segue.destinationViewController;
        controller.event = sender;
    } else if ([segue.identifier isEqualToString:@"toImages"]) {
        VANHeadShotController *controller = segue.destinationViewController;
        controller.event = sender;
    }
}
@end
