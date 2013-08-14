//
//  VANScrollViewTeamSelectionCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-21.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANScrollViewTeamSelectionCell.h"
#import "VANTeamColor.h"

@interface VANScrollViewTeamSelectionCell ()

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;

@end

@implementation VANScrollViewTeamSelectionCell

- (void)initiate {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.scrollViewer.backgroundColor = [UIColor darkGrayColor];
    self.scrollViewer.pagingEnabled = YES;
    self.scrollViewer.showsHorizontalScrollIndicator = NO;
    self.scrollViewer.delegate = self;
    self.pageController.currentPage = [self.athlete.teamSelected integerValue];
    [self gotoPageWithAnimation:NO];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    self.pageController.pageIndicatorTintColor = [teamColor findTeamColor];
    self.pageController.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.sideColor.backgroundColor = [teamColor findTeamColor];
    
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollViewer.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollViewer.contentOffset.x * 2.0f + pageWidth / (pageWidth * 2.0f)));
    
    self.pageController.currentPage = page;
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
}

-(void)loadPage:(NSInteger)page {
    
}

-(void)resizeTeamViewstoControllerViewSize:(CGSize *)size {
    
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollViewer.frame);
    NSUInteger page = floor((self.scrollViewer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageController.currentPage = page;
    self.athlete.teamSelected = [NSNumber numberWithInteger:page];
    [self saveManagedObjectContext:self.athlete];
    NSLog(@"Changing Team");

}

- (void)gotoPageWithAnimation:(BOOL)animated
{
    NSInteger page = self.pageController.currentPage;
    
    [self.scrollViewer setContentOffset:CGPointMake(self.frame.size.width *page, 0) animated:animated];
}

- (IBAction)changeScrollerfromController:(id)sender
{
    [self gotoPageWithAnimation:YES];    // YES = animate
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollViewer.frame);
    NSUInteger page = floor((self.scrollViewer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.athlete.teamSelected = [NSNumber numberWithInteger:page];
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
