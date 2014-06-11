//
//  VANCompareControllerViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/7/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANCompareController.h"

@interface VANCompareController ()


@property (strong, nonatomic) UINavigationController *navigationA;
@property (strong, nonatomic) UINavigationController *navigationB;

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIViewController *viewControllerB;


@end

@implementation VANCompareController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    _viewController = [[UIViewController alloc] init];
    _viewControllerB = [[UIViewController alloc] init];
    
    
    _navigationA = [[UINavigationController alloc] initWithRootViewController:_viewController];
    _navigationB = [[UINavigationController alloc] initWithRootViewController:_viewControllerB];
    _navigationA.view.translatesAutoresizingMaskIntoConstraints = NO;
    _navigationB.view.translatesAutoresizingMaskIntoConstraints = NO;

    [_viewA addSubview:_navigationA.view];
    [_viewB addSubview:_navigationB.view];
    
    NSDictionary *d = @{@"view": _navigationA.view};
    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:d];
    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:d];
    [_viewA addConstraints:v];
    [_viewA addConstraints:h];
    
    d = @{@"view": _navigationB.view};
    v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:d];
    h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:d];
    [_viewB addConstraints:v];
    [_viewB addConstraints:h];
    
    //Navigation A
    _navigationA.navigationBar.topItem.title = @"Item A";
    _navigationB.navigationBar.topItem.title = @"Item B";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
