//
//  VANFullNavigationViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-04-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANFullNavigationViewController.h"
#import "VANIntroViewController.h"
#import "VANTeamColor.h"

@interface VANFullNavigationViewController ()

@end

@implementation VANFullNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    VANTeamColor *anotherTeam = [[VANTeamColor alloc] init];
    self.colorView.backgroundColor = [anotherTeam findTeamColor];
    [self.navigationBar setTintColor:[anotherTeam findTeamColor]]; //tintColor Sets Button Color;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height - 5, self.view.frame.size.height, 1.5)];
    [self.navigationBar addSubview:self.colorView];
    self.interactivePopGestureRecognizer.enabled = YES;
    //dx[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
