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

static int kInsetTopDetailTable = 104.0f;
static int kInsetBottomActive = 350;

static NSString *rAthleteImages = @"images";


@interface VANAthleteListControllerPad ()

@property (nonatomic) BOOL detailVisible;
@property (nonatomic) BOOL tagVisible;
@property (strong, nonatomic) UINavigationBar *tagNav;
@property (strong, nonatomic) NSIndexPath *previouslySelectedAthlete;

@property (strong, nonatomic) VANPictureTaker *pictureTaker;
@property (strong, nonatomic) VANSoloImageViewer *darkView;
@property (strong, nonatomic) UIView *tagsView;

@property (strong, nonatomic) NSLayoutConstraint *tagViewLeft;
@property (nonatomic) float touchStart;

@end


@implementation VANAthleteListControllerPad

-(void)viewDidLoad
{
    [super viewDidLoad];

    if (!_tableViewDetailDelegate) {
        self.tableViewDetailDelegate = [[VANDetailTableDelegate alloc] initWithTableView:self.tableViewDetail];
        self.tableViewDetailDelegate.delegate = self;
        self.tableViewDetailDelegate.event = self.event;
    }
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeDetailTableView)];
    UINavigationItem *title = [self.detailNav.items firstObject];
    title.leftBarButtonItem = done;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    if (_tagVisible) {
        [_tableViewTagsDelegate saveMasterTagsArrayToFile];
    }
    
    [super viewWillDisappear:animated];
    
    [self.tableViewDetailDelegate prepareToLeaveAthleteProfile];
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewDetailDelegate.athlete) {
        [self.tableViewDetailDelegate prepareToLeaveAthleteProfile];
    }
    [self.tableView reloadData];

    // Find athlete and update Detail Table
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];
    
    self.athlete = athlete;
    
    
    [self.tableViewDetailDelegate updateAthlete:athlete];
    _detailNav.topItem.title = athlete.name;
    [self.tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
    if (self.tagVisible) [self closeTagsTable];
    
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
    [_tableViewDetailDelegate updateTagsCellWithAthlete:nil andReloadCell:YES];
}

-(void)VANAddTagCellBecameFirstResponder {
    [self adjustContentInsetsForEditing:YES];
}

-(void)VANAddTagCellIsReleasingFirstResponder {
    [self adjustContentInsetsForEditing:NO];
}

#pragma mark - Detail Table View Delegate Methods

-(void)closeDetailTableView
{
    self.tableViewDetailDelegate.athlete = nil;
    self.athlete = nil;
    UINavigationItem *title = [self.detailNav.items firstObject];
    title.title = @"";
    [self.tableViewDetail reloadData];
    [self closeTagsTable];
}

-(void)initiateTagsView
{
    //Build Wrapper View - will be moveable
    self.tagsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height)];
    [self.tagsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view insertSubview:self.tagsView belowSubview:self.tabBar];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tagsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tagsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.tagsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    
    self.tagViewLeft = [NSLayoutConstraint constraintWithItem:self.tagsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:(-self.tagsView.frame.size.width)];
    [self.view addConstraints:@[top, bottom, width, self.tagViewLeft]];
    
    //Build TableView
    self.tableViewTags = [[UITableView alloc] initWithFrame:self.tagsView.frame];
    [self.tableViewTags setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableViewTags.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableViewTags setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableViewTags.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //Build Table View Delegate
    self.tableViewTagsDelegate = [[VANTagsTableDelegate alloc] initWithTableView:self.tableViewTags];
    self.tableViewTagsDelegate.event = self.event;
    self.tableViewTagsDelegate.delegate = self;


    [self.tagsView insertSubview:self.tableViewTags atIndex:0];
    
    //Build Tags Navigation Bar
    self.tagNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.tagsView.frame.size.width, 35)];
    [self.tagNav setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tagNav setBarStyle:UIBarStyleBlack];
    
    
    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Characteristics"];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTagsTable)];
    [self.tagNav pushNavigationItem:title animated:NO];
    title.rightBarButtonItem = close;
    [self.tagsView insertSubview:self.tagNav aboveSubview:self.tableViewTags];
    
    NSDictionary *views = @{@"nav":self.tagNav, @"table":self.tableViewTags};
    NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nav][table]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
    NSArray *horiz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nav]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views];
    [self.tagsView addConstraints:horiz];
    horiz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views];
    [self.tagsView addConstraints:horiz];
    [self.tagsView addConstraints:vert];
    
    UIPanGestureRecognizer *closeGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToCloseTagsTable:)];
    closeGuesture.delegate = self;
    closeGuesture.maximumNumberOfTouches = 1;
    
    [self.tagsView addGestureRecognizer:closeGuesture];
}

-(void)introduceTagsViewWithAnimation:(BOOL)animate
{
    if (!self.tableViewTags) {
        [self initiateTagsView];
    }
    
    if (!self.tagVisible) {
        [self.tableViewTags setContentOffset:CGPointMake(0,0) animated:YES];
        [_tableViewTagsDelegate filterTagArraysWithAthlete:self.athlete];
        [self.view layoutIfNeeded];
        self.tagsView.hidden = NO;
        self.tagVisible = YES;
        self.tagViewLeft.constant = 0;
        
        [UIView animateWithDuration:0.4f animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self closeTagsTable];
    }
 //   [_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
}

-(void)updateAthleteListTable
{
    [self.tableView reloadData];
}

#pragma mark - VAN Athlete Image Profile Cell Delegate Methods

-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Image From"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (auth == AVAuthorizationStatusAuthorized || auth == AVAuthorizationStatusNotDetermined) {
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (!self.pictureTaker) {
                    self.pictureTaker = [[VANPictureTaker alloc] init];
                    self.pictureTaker.delegate = self;
                }
                [self.pictureTaker buildRearCameraView];
            }];
            [alert addAction:cameraAction];
        }
    };
    UIAlertAction* libraryAction = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (!self.pictureTaker) {
            self.pictureTaker = [[VANPictureTaker alloc] init];
            self.pictureTaker.delegate = self;
        }
        [self.pictureTaker buildLibraryView];
    }];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:libraryAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    Athlete *selectedAthlete = self.tableViewDetailDelegate.athlete;
    
    // Create a new Image and bind it to this athlete
    Image *newImage = (Image *)[VANGlobalMethods addNewRelationship:rAthleteImages toManagedObject:selectedAthlete andSave:NO];
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

-(void)presentViewController:(UIImagePickerController *)picker {
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Custom Methods


-(void)adjustContentInsetsForEditing:(BOOL)editing {
    if (editing) {
        self.tableViewDetail.contentInset = UIEdgeInsetsMake(0, 0, kInsetBottomActive, 0);
        self.tableViewTags.contentInset = UIEdgeInsetsMake(kInsetTopDetailTable, 0, kInsetBottomActive, 0);
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kInsetBottomActive, 0);
        self.detailNav.topItem.leftBarButtonItem.enabled = NO;
        self.tagNav.topItem.leftBarButtonItem.enabled = NO;
        
        
    } else {
        self.tableViewDetail.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableViewTags.contentInset =UIEdgeInsetsMake(kInsetTopDetailTable, 0, 0, 0);
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

-(IBAction)closeTagsTable {
    if (self.tagVisible) {
        [self.view layoutIfNeeded];
        self.tagViewLeft.constant = -self.view.frame.size.width;
        [UIView animateWithDuration:0.4f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL success) {
            self.tagsView.hidden = YES;
        }];
        
        [_tableViewTagsDelegate saveMasterTagsArrayToFile];
    }
    //[_tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
    self.tagVisible = NO;
}

-(void)swipeToCloseTagsTable:(UIPanGestureRecognizer *)swipe {
    CGPoint location = [swipe locationInView:self.view];
    CGPoint translation = [swipe translationInView:self.view];
    CGPoint veloctiy = [swipe velocityInView:self.view];

    
    if (swipe.state == UIGestureRecognizerStateChanged) {        
        if (translation.x < 0) {
            self.tagViewLeft.constant = translation.x;
            [self.view layoutIfNeeded];
        }
    } else if (swipe.state == UIGestureRecognizerStateEnded) {
        if (translation.x < -self.view.frame.size.width/8) {
            [self closeTagsTable];
        } else {
            self.tagViewLeft.constant = 0;
            [self.view layoutIfNeeded];
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //When Rotating the Orientation, this make sure that the Team slider is still inline;
    [self.tableViewDetailDelegate readjustTeamCellWithAnimation:YES];
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
