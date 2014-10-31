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
    [self.navigationBar setTintColor:[anotherTeam findTeamColor]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.colorView = [[UIView alloc] init];
    NSDictionary *dic = @{@"view":self.colorView};
    [self.colorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navigationBar addSubview:self.colorView];
    NSArray *hori = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:NSLayoutFormatAlignAllTop metrics:nil views:dic];
    NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(5)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:dic];
    [self.navigationBar addConstraints:hori];
    [self.navigationBar addConstraints:vert];

    self.interactivePopGestureRecognizer.enabled = YES;
}

@end
