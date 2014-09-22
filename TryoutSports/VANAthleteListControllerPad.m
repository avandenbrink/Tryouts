//
//  VANAthleteListControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteListControllerPad.h"
#import "VANAthleteEditControllerPad.h"
#import "VANTagsTable.h"
#import "VANAthleteListCellPad.h"
#import "Image.h"
#import "VANPictureTaker.h"

static int kInsetTopMainTable = 64;
static int kInsetTopDetailTable = 104.0f;
static int kInsetBottom = 55;
static int kInsetBottomActive = 350;

static NSString *rAthleteImages = @"images";


@interface VANAthleteListControllerPad ()

@property (nonatomic) BOOL detailVisible;
@property (nonatomic) BOOL tagVisible;
@property (strong, nonatomic) UINavigationBar *detailNav;
@property (strong, nonatomic) UINavigationBar *tagNav;
@property (strong, nonatomic) NSIndexPath *previouslySelectedAthlete;

//Auto Layout Constraints for Tables
//Main List Table Constraints
@property (strong, nonatomic) NSArray *rightTableConstraint;
@property (strong, nonatomic) NSArray *leftTableConstraint;
@property (strong, nonatomic) NSLayoutConstraint *mainWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *mainTripleConstraint;
@property (strong, nonatomic) NSArray *leftTableTagsActiveConstraint;

//Detail Table Constraints
@property (strong, nonatomic) NSLayoutConstraint *detailWidthConstraint; // Will change with Tags only
@property (strong, nonatomic) NSArray *detailRightHiddenConstraint;
@property (strong, nonatomic) NSArray *detailAlignLeftToTablesRightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *detailTripleConstraint;
//Detail Nav Bar Constraints Are all Constant

//Tag Table Bar Constraint
@property (strong, nonatomic) NSLayoutConstraint *tagWidthConstraint;
@property (strong, nonatomic) NSArray *tagRightHiddenConstraint;
@property (strong, nonatomic) NSArray *tagRightActiveConstraint;
@property (strong, nonatomic) NSLayoutConstraint *hugToDetail;

@property (strong, nonatomic) VANPictureTaker *pictureTaker;
@property (strong, nonatomic) VANSoloImageViewer *darkView;

@end


@implementation VANAthleteListControllerPad

-(void)viewDidLoad
{
    [super viewDidLoad];
        
   // self.tableView.contentInset = UIEdgeInsetsMake(kInsetTopMainTable, 0, kInsetBottom, 0);
    
    //[self.view removeConstraints:self.view.constraints];
    
    //Set up Auto Layout for Main TableView:
//    self.rightTableConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[table]|" options:0 metrics:0 views:@{@"table": self.tableView}];
//    self.leftTableConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[table]" options:0 metrics:0 views:@{@"table": self.tableView}];
//    NSArray *tableVerticalConstratin = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:0 views:@{@"table": self.tableView}];
//    [self.view addConstraints:self.rightTableConstraint];
//    [self.view addConstraints:self.leftTableConstraint];
//    [self.view addConstraints:tableVerticalConstratin];
    NSArray *tabWidthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[Tab]|" options:0 metrics:0 views:@{@"Tab": self.tabBar}];
    NSArray *tabHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[Tab]|" options:0 metrics:0 views:@{@"Tab": self.tabBar}];
    [self.view addConstraints:tabWidthConstraints];
    [self.view addConstraints:tabHeightConstraint];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.closeTabsButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraint:trailing];
    
    self.closeTabsButton.hidden = YES;
    
    NSDictionary *dic = @{@"button": self.closeTabsButton, @"label": self.starterLabel};
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:0 views:dic];
    NSArray *horizon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(60)]" options:0 metrics:0 views:dic];
    [self.view addConstraints:vertical];
    [self.closeTabsButton addConstraints:horizon];
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:0 views:dic];
    horizon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:0 views:dic];
    [self.view addConstraints:vertical];
    [self.view addConstraints:horizon];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set up AthleteDetailTable if it is not already built as well as its DataSource and Delegate;
    
    if (!_tableViewDetail) {
        
        _tableViewDetail = [[VANAthleteDetailTable alloc] init];
        [_tableViewDetail setTranslatesAutoresizingMaskIntoConstraints:NO];
        _tableViewDetail.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottom, 0);
        _tableViewDetail.backgroundColor = [UIColor darkGrayColor];
        _tableViewDetail.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (!_tableViewDetailDelegate) {
            self.tableViewDetailDelegate = [[VANDetailTableDelegate alloc] initWithTableView:self.tableViewDetail];
            self.tableViewDetailDelegate.delegate = self;
            self.tableViewDetailDelegate.event = self.event;
        }
        
        if ([self.event.athletes count] > 0) {
            _tableViewDetailDelegate.athlete = [[self.event.athletes allObjects] objectAtIndex:0];
        }
        
        self.detailNav = [[UINavigationBar alloc] init];
        [self.detailNav setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.detailNav.barStyle = UIBarStyleBlackOpaque;
        
        UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Athlete"];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleDetailVisible)];
        [self.detailNav pushNavigationItem:title animated:NO];
        title.leftBarButtonItem = done;
        [self.view insertSubview:self.tableViewDetail atIndex:0];
        [self.view insertSubview:self.detailNav aboveSubview:self.tableViewDetail];
        
        //Detail Navigation Bar Constraints
        NSDictionary *dic = @{@"table": self.tableViewDetail, @"nav": self.detailNav};
        NSArray *navTopConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[nav]" options:0 metrics:nil views:dic];
        NSLayoutConstraint *alignLeft = [NSLayoutConstraint constraintWithItem:self.detailNav attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableViewDetail attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *alignRight = [NSLayoutConstraint constraintWithItem:self.detailNav attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableViewDetail attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];

        [self.view addConstraints:navTopConstraint];
        [self.view addConstraint:alignLeft];
        [self.view addConstraint:alignRight];
        
        //Detail Table Constriaints Constraints
        NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:dic];
        self.detailWidthConstraint = [NSLayoutConstraint constraintWithItem:self.tableViewDetail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
        self.detailRightHiddenConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[table]-(-80)-|" options:0 metrics:nil views:dic];
        
        [self.view addConstraints:verticalConstraint];
        [self.view addConstraint:self.detailWidthConstraint];
        [self.view addConstraints:self.detailRightHiddenConstraint];
    }
    
    //Will be coming to change this section soon enough
    if (!self.tableViewTags) {
        
        self.tableViewTags = [[UITableView alloc] init];
        [self.tableViewTags setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        if (!_tableViewTagsDelegate) {
            //Build Our Table Delegate and Datasource Object
            _tableViewTagsDelegate = [[VANTagsTableDelegate alloc] initWithTableView:self.tableViewTags];
            _tableViewTagsDelegate.event = self.event;
            _tableViewTagsDelegate.delegate = self;
        }
        

        
        [self.view insertSubview:self.tableViewTags atIndex:0];
        self.tableViewTags.contentInset = UIEdgeInsetsMake(44, 0, kInsetBottom, 0);
        
        self.tagNav = [[UINavigationBar alloc] init];
        [self.tagNav setTranslatesAutoresizingMaskIntoConstraints:NO];
        UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Characteristics"];
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTagsTable)];
        [self.tagNav pushNavigationItem:title animated:NO];
        title.leftBarButtonItem = close;

        [self.view insertSubview:self.tagNav aboveSubview:self.tableViewTags];
        
        //Constraints
        NSDictionary *dic = @{@"nav": self.tagNav, @"table": self.tableViewTags};
        
        //Tag Navigation Bar Constraints
        NSArray *verticalNavConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[nav]" options:0 metrics:nil views:dic];
        NSLayoutConstraint *alignNavLeft = [NSLayoutConstraint constraintWithItem:self.tagNav attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableViewTags attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *alignNavRight = [NSLayoutConstraint constraintWithItem:self.tagNav attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableViewTags attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        [self.view addConstraints:verticalNavConstraint];
        [self.view addConstraint:alignNavLeft];
        [self.view addConstraint:alignNavRight];
        
        //Tag Table Constraints
        NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:dic];
        [self.view addConstraints:verticalConstraint];
        self.tagWidthConstraint = [NSLayoutConstraint constraintWithItem:self.tableViewTags attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.3333333 constant:0];
        [self.view addConstraint:self.tagWidthConstraint];
        self.tagRightHiddenConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[table]|" options:0 metrics:nil views:dic];
        [self.view addConstraints:self.tagRightHiddenConstraint];
    }
    
    [self toggleTablesVisible];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_tagVisible) {
        [_tableViewTagsDelegate saveMasterTagsArrayToFile];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//B. Find selected Cell's Athlete and pass it to the AthleteDetail TableView and ask it to reload its data after making sure that it is loaded
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];
    
    _tableViewDetailDelegate.athlete = athlete;
    _tableViewDetailDelegate.config.athlete = athlete;
    
    _detailNav.topItem.title = athlete.name; // Giving the Naviagation bar above the Athlete Detail the Name for a title
    [_tableViewDetailDelegate updateAthleteTagsCellWithAthlete:athlete andReloadCell:NO]; //Asks UICollectionView in AthelteDetailTable cell reload
    
    [_tableViewDetail reloadData];
    if (!_detailVisible) {
        [self toggleDetailVisible];
    }
    [_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
    
    //C. Also pass the selected Athlete to the Tags Table View and ask it to reload its view.
    //This could potentially be done through AthleteDetails didselecterowatIndex to use lazy loading, however the table has already been loaded into view in view will appear.  And we must ask Tags Table to close if openned at this point either way.
    
    [_tableViewTagsDelegate filterTagArraysWithAthlete:athlete];
    
      //Resorting the Tags in this tableview based on the plist that has been saved to reflect the new athlete's Characteristics.  This is done from plist each time, becuase of the filter option may change the currently available tags that are loaded into memory.
    [self.tableViewTags setContentOffset:CGPointMake(0,-104) animated:YES]; //Reseting the scroll of the Tags Table View to ensure that it begins at the top of the table
    //Asking the Tag View to close if it was openned while a previous athlete was being edited as well
    if ((self.tagVisible)) {
        [self closeTagsTable];
    }
    [self.tableViewTags reloadData];
    
    [VANGlobalMethods saveManagedObject:self.event];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}


- (void)animateWithOffset:(CGFloat)offset {

}

#pragma mark - VAN Tags Table Delegate Delegate Methods

-(void)athleteTagProfileHasBeenUpdated {
    [_tableViewDetailDelegate updateAthleteTagsCellWithAthlete:nil andReloadCell:YES];
}

-(void)VANAddTagCellBecameFirstResponder {
    [self adjustContentInsetsForEditing:YES];
}

-(void)VANAddTagCellIsReleasingFirstResponder {
    [self adjustContentInsetsForEditing:NO];
}

#pragma mark - VAN Athlete Image Profile Cell Delegate Methods

-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell
{
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
        self.pictureTaker.delegate = self;
    }
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Image from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Use Camera" otherButtonTitles:@"Pick from library", nil];
    [action showInView:self.view];
}

- (void)VANTableViewCellrequestsImageforAthete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell
{
    [self.tableViewDetail setContentOffset:CGPointMake(0, -104)];
    
    CGPoint offset = cell.imageScrollView.contentOffset;
    CGFloat imageNumber = offset.x/cell.imageScrollView.frame.size.width;
    NSArray *images = [athlete.images allObjects];
    Image *headshot = [images objectAtIndex:imageNumber];
    
    if (!self.darkView) {
        self.darkView = [[VANSoloImageViewer alloc] initWithFrame:self.view.frame andImage:headshot];
        [self.view addSubview:self.darkView];
        self.darkView.delegate = self;
    } else {
        NSMutableArray *subviews = [self.view.subviews mutableCopy];
        if (![[subviews objectAtIndex:[subviews count]-1] isKindOfClass:[VANSoloImageViewer class]]) {
            [self.view bringSubviewToFront:self.darkView];
        }
    }
    CGRect startView = CGRectMake(self.tableViewDetail.frame.origin.x+cell.frame.origin.x,
                                  self.tableViewDetail.frame.origin.y+cell.frame.origin.y,
                                  cell.frame.size.height, cell.frame.size.height);
    [self.darkView animateInImageViewerWithImage:headshot andInitialPosition:startView];
}

#pragma mark - UIAction Sheed delegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        self.pictureTaker.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        if (buttonIndex == 1) {
            self.pictureTaker.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:self.pictureTaker.imagePicker.sourceType]) {
        [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Image source is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - VAN Solo Image Viewer Delegate Methods

-(void)deleteImagefromSoloImageViewer:(Image *)image {
    [self.tableViewDetail reloadData];
}

-(void)closeSoloImageViewer {
    NSLog(@"Close Solo Image Viewer");
}

-(void)requiresUIUpdating {
}

#pragma mark - VAN Athlete Edit Controller Methods

-(void)closeAthleteEditPopover
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self sortAthletesByIndex:self.tabBar.selectedItem.tag];
    [self.tableView reloadData];
}

#pragma mark - VAN Picture Taker Deletage Methods

-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passBackSelectedImageData:(NSData *)imageData
{   // Image is passed back from camera
    
    // Firstly collect the image that we are currently editing:
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Athlete *selectedAthlete = self.tableViewDetailDelegate.athlete;
    
    // Create a new Image and bind it to this athlete
    Image *newImage = (Image *)[methods addNewRelationship:rAthleteImages toManagedObject:selectedAthlete andSave:NO];
    newImage.headShot = imageData;
    
    // Make this image the profile image if it is the only image attached to the athlete
    if ([selectedAthlete.images count] == 1) {
        selectedAthlete.profileImage = newImage;
    }
    
    //Update our Athlete Detail Cell to include this new image
    VANAthleteProfileCell *cell =  (VANAthleteProfileCell *)[self.tableViewDetail cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell addNewImageFromData:imageData];
    [VANGlobalMethods saveManagedObject:selectedAthlete];
    
    [self.imageCache setValue:[UIImage imageWithData:imageData] forKey:selectedAthlete.name];
    
    [self.tableViewDetail reloadData];
}


#pragma mark - Custom Methods


-(void)adjustContentInsetsForEditing:(BOOL)editing {
    if (editing) {
        self.tableViewDetail.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottomActive, 0);
        self.tableViewTags.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottomActive, 0);
        self.tableView.contentInset = UIEdgeInsetsMake(kInsetTopMainTable, 0, kInsetBottomActive, 0);
        self.detailNav.topItem.leftBarButtonItem.enabled = NO;
        self.tagNav.topItem.leftBarButtonItem.enabled = NO;
        
        
    } else {
        self.tableViewDetail.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottom, 0);
        self.tableViewTags.contentInset =UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottom, 0);
        self.tableView.contentInset = UIEdgeInsetsMake(kInsetTopMainTable, 0, kInsetBottom, 0);
        self.detailNav.topItem.leftBarButtonItem.enabled = YES;
        self.tagNav.topItem.leftBarButtonItem.enabled = YES;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewAthletePage"]) {
        UINavigationController *nav = segue.destinationViewController;
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.navigationBar.tintColor = [self.teamColor findTeamColor];
        VANAthleteEditControllerPad *controller = (VANAthleteEditControllerPad *)[nav topViewController];
        controller.event = self.event;
        controller.delegate = self;
        if (sender) {
            controller.athlete = sender;
        } else {
            controller.isNew = YES;
        }
    }
}

-(void)toggleDetailVisible {
    [self.view layoutSubviews];
    [UIView animateWithDuration:0.4f animations:^{
        if (self.detailVisible) { //If Currently Visible, Make it Not Visible
            if (self.tagVisible) { // If Tags TableView is Visible, make it not visible
                self.tagVisible = NO;
                //Main Table
                if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                    [self removePortaitTableConstraint];
                }
                [self.view removeConstraint:self.mainTripleConstraint];
                [self.view addConstraints:self.rightTableConstraint];
                //Detail View
                [self.view removeConstraint:self.detailTripleConstraint];
                [self.view removeConstraints:self.detailAlignLeftToTablesRightConstraint];
                [self.view addConstraints:self.detailRightHiddenConstraint];
                [self.view addConstraint:self.detailWidthConstraint];
                
                [_tableViewTagsDelegate saveMasterTagsArrayToFile];
            } else {
                //Main View
                [self.view removeConstraint:self.mainWidthConstraint];
                [self.view addConstraints:self.rightTableConstraint];
                //Detail View
                [self.view removeConstraints:self.detailAlignLeftToTablesRightConstraint];
                [self.view addConstraints:self.detailRightHiddenConstraint];
            }
            [self.tableView reloadData];
            self.detailVisible = NO;
            
        } else { //If Detail is not Visible, make it visible
            //Main Table
            if (!self.mainWidthConstraint) {
                self.mainWidthConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
            }
            
            [self.view removeConstraints:self.rightTableConstraint];
            [self.view addConstraint:self.mainWidthConstraint];

            //Detail
            if (!self.detailAlignLeftToTablesRightConstraint) {
                self.detailAlignLeftToTablesRightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[table][detail]" options:0 metrics:nil views:@{@"table": self.tableView,@"detail": self.tableViewDetail}];
            }
            
            [self.view removeConstraints:self.detailRightHiddenConstraint];
            [self.view addConstraints:self.detailAlignLeftToTablesRightConstraint];
            
            self.detailVisible = YES;
        }
        [self.view layoutSubviews];
    } completion:^(BOOL success) {
      //  [self.athleteDetailTable readjustTeamCellWithAnimation:NO];
    }];
}

-(IBAction)closeTagsTable {
    if (self.tagVisible) {
        [self.view layoutSubviews];
        [UIView animateWithDuration:0.4f animations:^{
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                [self removePortaitTableConstraint];
            }
            
            [self.view removeConstraint:self.mainTripleConstraint];
            [self.view addConstraint:self.mainWidthConstraint];
            
            [self.view removeConstraint:self.detailTripleConstraint];
            [self.view addConstraint:self.detailWidthConstraint];
            
            [self.view removeConstraints:self.tagRightActiveConstraint];
            [self.view addConstraints:self.tagRightHiddenConstraint];
            [self.view layoutSubviews];
        }];
        
        [_tableViewTagsDelegate saveMasterTagsArrayToFile];
        
    }
    [_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
    self.tagVisible = NO;
}

-(void)introduceTagsViewWithAnimation:(BOOL)animate {
    
    if (!self.tagVisible) {
        [self.view layoutSubviews];
        self.tagVisible = YES;
        [UIView animateWithDuration:0.4f animations:^{
            
            //Main Table - Already has Vertical and Left Constraints
            if (!self.mainTripleConstraint) {
                self.mainTripleConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.33333 constant:0];
            }
            [self.view removeConstraint:self.mainWidthConstraint]; // Remove 50% Width
            [self.view addConstraint:self.mainTripleConstraint]; //Add 1/3 Width
            
            //Detail Table - Already has Vertical and Alingment to Main Table
            if (!self.detailTripleConstraint) {
                self.detailTripleConstraint = [NSLayoutConstraint constraintWithItem:self.tableViewDetail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.33333 constant:0];
            }
            [self.view removeConstraint:self.detailWidthConstraint];
            [self.view addConstraint:self.detailTripleConstraint];
            
            //Tag Table - Already has Width and
            if (!self.tagRightActiveConstraint) {
                self.tagRightActiveConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[tag]|" options:0 metrics:nil views:@{@"tag": self.tableViewTags}];
            }
            [self.view removeConstraints:self.tagRightHiddenConstraint];
            [self.view addConstraints:self.tagRightActiveConstraint];
            
            //Custom Adjustments for Portrait vs Landscape
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                [self addPortaitTableConstraints];
            }
            [self.view layoutSubviews];
        }];
    } else {
        [self closeTagsTable];
    }
    [_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
}

-(void)addPortaitTableConstraints{
    if (!self.leftTableTagsActiveConstraint) {
        NSDictionary *dic = @{@"table":self.tableView};
        self.leftTableTagsActiveConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(-200)-[table]" options:0 metrics:0 views:dic];
    }
    [self.view removeConstraints:self.leftTableConstraint];
    [self.view addConstraints:self.leftTableTagsActiveConstraint];
    
    [self.view removeConstraint:self.detailTripleConstraint];
    [self.view addConstraint:self.detailWidthConstraint];
    [self.view removeConstraint:self.tagWidthConstraint];
    if (!self.hugToDetail) {
        self.hugToDetail = [NSLayoutConstraint constraintWithItem:self.tableViewTags attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableViewDetail attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    }
    [self.view addConstraint:self.hugToDetail];
    self.closeTabsButton.hidden = NO;
    self.tableView.allowsSelection = NO;
}

-(void)removePortaitTableConstraint {
    [self.view removeConstraints:self.leftTableTagsActiveConstraint];
    [self.view addConstraints:self.leftTableConstraint];
    [self.view removeConstraint:self.detailWidthConstraint];
    [self.view addConstraint:self.detailTripleConstraint];
    [self.view removeConstraint:self.hugToDetail];
    [self.view addConstraint:self.tagWidthConstraint];
    self.closeTabsButton.hidden = YES;
    self.tableView.allowsSelection = YES;
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.view layoutSubviews];
    [UIView animateWithDuration:duration animations:^{
        if (self.tagVisible) {
            if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
                [self addPortaitTableConstraints];
            } else {
                [self removePortaitTableConstraint];
            }
        }
        [self.view layoutSubviews];
        [_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
    }];
}

-(void)toggleTablesVisible {
    if ([self.event.athletes count] > 0) {
        self.tableView.hidden = NO;
        self.starterLabel.hidden = YES;
        self.detailNav.hidden = NO;
        self.tagNav.hidden = NO;
    } else {
        self.tableView.hidden = YES;
        self.starterLabel.hidden = NO;
        self.detailNav.hidden = YES;
        self.tagNav.hidden = YES;
    }
}

@end
