//
//  VANScrollViewTeamSelectionCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-21.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#import "Event.h"
#import "TeamName.h"
#import "VANScrollViewTeamSelectionCell.h"
#import "VANTeamColor.h"

@interface VANScrollViewTeamSelectionCell ()

@property (strong, nonatomic) UIView *lastView;
@property (strong, nonatomic) NSArray *teamsArray;

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;

@end

@implementation VANScrollViewTeamSelectionCell

- (void)setTeamPageForAthlete:(Athlete *)athlete;
{
    self.athlete = athlete;
    
    if (!_viewer) {
        [self initiate];
    }
    
    if ([self.athlete.isCut isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        _pageController.currentPage = 0;
    } else if (self.athlete.teamName) {
        _pageController.currentPage = [self.athlete.teamName.index intValue]+ 2;
    } else {
        _pageController.currentPage = 1;
    }
    
    [self gotoPageWithAnimation:NO];
}



- (void)initiate {
    self.backgroundColor = [UIColor darkGrayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _scrollViewer.backgroundColor = [UIColor darkGrayColor];
    _scrollViewer.pagingEnabled = YES;
    _scrollViewer.showsHorizontalScrollIndicator = NO;
    _scrollViewer.delegate = self;
    
    NSMutableArray *teamsArray = [NSMutableArray arrayWithObjects:@"Cut", @"No Team", nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *t = [[self.athlete.event.teamNames allObjects] sortedArrayUsingDescriptors:@[sort]];
    for (TeamName *team in t) {
        [teamsArray addObject:team.name];
    }
    
    _pageController.numberOfPages = [teamsArray count];
    
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    _pageController.pageIndicatorTintColor = [teamColor findTeamColor];
    _pageController.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    if (!_viewer) {
        _viewer = [[UIView alloc] init];
        [_scrollViewer addSubview:_viewer];
        
        _viewer.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *d = @{@"viewer": _viewer};
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewer]|" options:0 metrics:0 views:d];
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewer]|" options:0 metrics:0 views:d];
        
        [_scrollViewer addConstraints:v];
        [_scrollViewer addConstraints:h];
    }
    
    for (int i = 0; i < [teamsArray count]; i++) {
        
        UIView *view = [[UIView alloc] init];
        [self.viewer addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;

        //View Constraints
        NSDictionary *dict = NSDictionaryOfVariableBindings(view);
        NSArray *verticle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:dict];
        [self.viewer addConstraints:verticle];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollViewer attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [self.scrollViewer addConstraint:width];
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollViewer attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [self.scrollViewer addConstraint:height];
        
        if (self.lastView) {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lastView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
            [self.viewer addConstraint:left];
        } else {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.viewer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
            [self.viewer addConstraint:left];
        }
        self.lastView = view;
        if (i == [teamsArray count]-1) {
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.viewer attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
            [self.viewer addConstraint:right];
        }
        
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        //Label Constraints
        NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:@{@"label": label}];
        NSArray *hori = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:@{@"label": label}];
        [view addConstraints:vert];
        [view addConstraints:hori];
        
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [teamsArray objectAtIndex:i];
        
        
        
        if (i == 0) {
            view.backgroundColor = [UIColor lightGrayColor];
        } else if (i == 1) {
            view.backgroundColor = [UIColor darkGrayColor];
        } else {
            VANTeamColor *teamColor = [[VANTeamColor alloc] init];
            view.backgroundColor = [teamColor findTeamColor];
            if ([teamColor findTeamColor] == [UIColor whiteColor]) {
                label.textColor = [UIColor blackColor];
            }
        }
    }

//    [self gotoPageWithAnimation:YES];
}

-(void)resizeTeamViewstoControllerViewSize:(CGSize *)size {
    
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //Called Only when a Finger Swipe is used to change the team's page position;
    CGFloat pageWidth = CGRectGetWidth(self.scrollViewer.frame);
    NSUInteger page = floor((self.scrollViewer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageController.currentPage = page;
    
    [self saveAthletesNewTeamTo:page];

}

- (IBAction)changeScrollerfromController:(id)sender
{
    [self gotoPageWithAnimation:YES];
    NSUInteger page = self.pageController.currentPage;
    [self saveAthletesNewTeamTo:page];

}

- (void)gotoPageWithAnimation:(BOOL)animated
{
    NSInteger page = self.pageController.currentPage;
    CGPoint frame = CGPointMake(self.frame.size.width *page, 0);
    if (animated) {
        [self.scrollViewer setContentOffset:frame animated:animated];
    } else {
        self.scrollViewer.contentOffset = frame;
    }
}

-(void)saveAthletesNewTeamTo:(NSInteger)team
{
    if (team == 0) {
        self.athlete.isCut = [NSNumber numberWithBool:YES];
        self.athlete.teamName = nil;
    } else if (team == 1) {
        self.athlete.isCut = [NSNumber numberWithBool:NO];
        self.athlete.teamName = nil;
    } else {
        self.athlete.isCut = [NSNumber numberWithBool:NO];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *teams = [self.athlete.event.teamNames sortedArrayUsingDescriptors:@[sort]];
        TeamName *t = [teams objectAtIndex:team-2];
        self.athlete.teamName = t;
    }
    [self saveManagedObjectContext:self.athlete];
}

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}


@end
