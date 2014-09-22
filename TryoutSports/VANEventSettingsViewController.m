//
//  VANEventSettingsViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-14.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANEventSettingsViewController.h"

@interface VANEventSettingsViewController ()

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@end

@implementation VANEventSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveEvent:)];
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.frame = CGRectMake(0, 0, 320, 504);
    self.scrollerView.contentSize = CGSizeMake(self.scrollerView.frame.size.width * 3, 504);
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.pageController.numberOfPages = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveEvent:(id)sender {
   /* for (VANNewEventEditCell *cell in [self.tableView visibleCells]) {
        if ([cell.dataType isEqual: @"NSNumber"]) {
            [self.myNewEvent setValue:[NSNumber numberWithInt:[[cell value] intValue]] forKey:[cell key]];
        } else if ([cell.dataType isEqualToString:@"Bool"]) {
            if ([cell.textField.text isEqual: @"1"]) {
                [self.myNewEvent setValue:[NSNumber numberWithInt:1] forKey:cell.key];
            } else {
                [self.myNewEvent setValue:[NSNumber numberWithInt:2] forKey:cell.key];
            }
        } else {
            [self.myNewEvent setValue:[cell value] forKey:[cell key]];
        }
    }
    NSError *error;
    if (![self.myNewEvent.managedObjectContext save:&error]) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    [self.tableView reloadData];*/
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel
{    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollerView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollerView.contentOffset.x * 2.0f + pageWidth / (pageWidth * 2.0f)));
    
    self.pageController.currentPage = page;
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
}

-(void)loadPage:(NSInteger)page {
    
}


// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollerView.frame);
    NSUInteger page = floor((self.scrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageController.currentPage = page;
   // self.athlete.teamSelected = [NSNumber numberWithInteger:page];
  //  [self saveManagedObjectContext:self.athlete];
}

- (void)gotoPage:(BOOL)animated {
 
    NSInteger page = self.pageController.currentPage;
    [self.scrollerView setContentOffset:CGPointMake(320 *page, 0) animated:animated];
    
}


- (IBAction)changeScrollerfromController:(id)sender {
    [self gotoPage:YES];    // YES = animate
}


-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}


@end
