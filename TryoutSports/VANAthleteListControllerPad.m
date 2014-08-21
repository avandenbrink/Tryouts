#warning - Still need to adjust tags table to implement rules that aren't use with -viewdiddisappear
#warning - Need to build functionality into Image Profile Viewer
#warning - Need to hook up New Athlete Controller
#warning - Need to Figure out Main Table View Cell's

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

-(void)viewDidLoad {
    
    [super viewDidLoad];
    //Ensure BOOL's are set
    self.detailVisible = NO;
    self.tagVisible = NO;
    
    //Make sure Tab Bar has Ordered by Name selected First
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:0];
    if ([self.teamColor findTeamColor] == [UIColor whiteColor]) { //If Team Color is White need to make special arangments
        self.tabBar.tintColor = [UIColor blackColor];
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(kInsetTopMainTable, 0, kInsetBottom, 0);
    
    [self.view removeConstraints:self.view.constraints];
    
    //Set up Auto Layout for Main TableView:
    self.rightTableConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[table]|" options:0 metrics:0 views:@{@"table": self.tableView}];
    self.leftTableConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[table]" options:0 metrics:0 views:@{@"table": self.tableView}];
    NSArray *tableVerticalConstratin = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:0 views:@{@"table": self.tableView}];
    [self.view addConstraints:self.rightTableConstraint];
    [self.view addConstraints:self.leftTableConstraint];
    [self.view addConstraints:tableVerticalConstratin];
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sortAthletesByName];
    
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

#pragma mark - Sorting Methods

-(void)sortAthletesByName {
    NSArray *array = [self.event.athletes allObjects];
    self.athleteLister = [NSMutableDictionary dictionary];
    self.sectionArray = [NSMutableArray array];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByName]];
    for (Athlete *athlete in sortedArray) {
        NSString *name = athlete.name;
        NSString *firstLetter = [name substringToIndex:1];
        if (![self.athleteLister objectForKey:firstLetter]) {
            NSMutableArray *array = [NSMutableArray arrayWithObject:athlete];
            [self.athleteLister setValue:array forKey:firstLetter];
            [self.sectionArray addObject:firstLetter];
        } else {
            NSMutableArray *array = [self.athleteLister objectForKey:firstLetter];
            [array addObject:athlete];
        }
    }
}

-(void)sortAthletesByPosition {
    NSArray *array = [self.event.athletes allObjects];
    self.athleteLister = [NSMutableDictionary dictionary];
    self.sectionArray = [NSMutableArray array];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortByPosition = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByPosition, sortByName]];
    for (Athlete *athlete in sortedArray) {
        NSString *position = athlete.position;
        if (!athlete.position) {
            position = @"No Position Yet";
        }
        if (![self.athleteLister objectForKey:position]) {
            NSMutableArray *array = [NSMutableArray arrayWithObject:athlete];
            [self.athleteLister setValue:array forKey:position];
            [self.sectionArray addObject:position];
        } else {
            NSMutableArray *array = [self.athleteLister objectForKey:position];
            [array addObject:athlete];
        }
    }
}

-(void)sortAthletesBySeen {
    NSArray *array = [self.event.athletes allObjects];
    self.athleteLister = [NSMutableDictionary dictionary];
    self.sectionArray = [NSMutableArray arrayWithObjects:@"Unseen", @"Seen", nil];

    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByName]];
    
    for (Athlete *athlete in sortedArray) {
        BOOL seen = [athlete.seen boolValue];
        if (![self.athleteLister objectForKey:[self.sectionArray objectAtIndex:0]]) {
            NSMutableArray *arrayA = [NSMutableArray array];
            NSMutableArray *arrayB = [NSMutableArray array];
            [self.athleteLister setValue:arrayA forKey:[self.sectionArray objectAtIndex:0]];
            [self.athleteLister setValue:arrayB forKey:[self.sectionArray objectAtIndex:1]];
        }
        if (!seen) {
            NSMutableArray *array = [self.athleteLister objectForKey:[self.sectionArray objectAtIndex:0]];
            [array addObject:athlete];
        } else {
            NSMutableArray *array = [self.athleteLister objectForKey:[self.sectionArray objectAtIndex:1]];
            [array addObject:athlete];
        }
    }
}


-(void)sortAthletesByNumber {
    NSArray *array = [self.event.athletes allObjects];
    self.athleteLister = [NSMutableDictionary dictionary];
    self.sectionArray = [NSMutableArray arrayWithObject:@"Numbers"];
    NSSortDescriptor *sortByNumber = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByNumber]];
    [self.athleteLister setObject:sortedArray forKey:[self.sectionArray objectAtIndex:0]];
}

-(void)sortAthletesByFlagged {
    NSArray *array = [self.event.athletes allObjects];
    self.athleteLister = [NSMutableDictionary dictionary];
    self.sectionArray = [NSMutableArray arrayWithObject:@"Flagged"];
    
    NSSortDescriptor *sortByNumber = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByNumber]];
    
    NSMutableArray *filteredArray = [NSMutableArray array];
    //Filter Array
    for (Athlete *athlete in sortedArray) {
        if ([athlete.flagged boolValue]) {
            [filteredArray addObject:athlete];
        }
    }
    [self.athleteLister setObject:filteredArray forKey:[self.sectionArray objectAtIndex:0]];
}

/*
-(void)addNewAthlete:(id)sender {
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Athlete *athlete = (Athlete *)[methods addNewRelationship:@"athletes" toManagedObject:self.event andSave:NO];
    [self performSegueWithIdentifier:@"toNewAthlete" sender:athlete];
    
}*/

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:section]];
    return [array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VANAthleteListCellPad *cell = (VANAthleteListCellPad *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];
    
    //Setup Athlete Name,
    [self setupAthleteListCell:cell withAthlete:athlete forIndexPath:indexPath];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionArray objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    UITabBarItem *item = self.tabBar.selectedItem;
    if ([item isEqual:[self.tabBar.items objectAtIndex:0]]) {
        return self.sectionArray;
    } else {
        return nil;
    }
}

#pragma mark - Table View Delegate Methods



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//A. Reload Main TableViews Data to reflect any changes to the previously selected cell's Athlete
    [self.tableView reloadData];

//B. Find selected Cell's Athlete and pass it to the AthleteDetail TableView and ask it to reload its data after making sure that it is loaded
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];
    
    _tableViewDetailDelegate.athlete = athlete;
    _tableViewDetailDelegate.config.athlete = athlete;
    
    _detailNav.topItem.title = athlete.name; // Giving the Naviagation bar above the Athlete Detail the Name for a title
    [_tableViewDetailDelegate updateAthleteTagsCellWithAthlete:athlete]; //Asks UICollectionView in AthelteDetailTable cell reload
    
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
    
// D. Make any neccesary changes to the Selected Athlete itself.
    athlete.seen = [NSNumber numberWithBool:YES]; //Ensuring that it has been reflected that this athlete has been Seen by the user and their profile has actively been selected.

    
    
    
//B. Figure out a way to Change the selected cell in Table View to show that it has been selected and differenciate it from the other athletes in the Table
   /*
    [UIView animateWithDuration:0.2f animations:^{
        VANAthleteListCellPad *cell = (VANAthleteListCellPad *)[tableView cellForRowAtIndexPath:indexPath];
        
        CGPoint center = {cell.contentView.center.x, cell.contentView.center.y};
        CGPoint centerActive;

        if (self.previouslySelectedAthlete) {
            VANAthleteListCellPad *prev = (VANAthleteListCellPad *)[tableView cellForRowAtIndexPath:self.previouslySelectedAthlete];
            [prev.contentView setCenter:center];
            centerActive = CGPointMake(prev.contentView.center.x + 15, prev.contentView.center.y);
        } else {
            centerActive = CGPointMake(cell.contentView.center.x + 15, cell.contentView.center.y);
        }
        [cell.contentView setCenter:centerActive];

        self.previouslySelectedAthlete = indexPath;
        //CGRect f = cell.contentView.frame;
    }];*/
    
    VANGlobalMethods *global = [[VANGlobalMethods alloc] initwithEvent:self.event];
    [global saveManagedObject:self.event];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}


- (void)animateWithOffset:(CGFloat)offset {

}

#pragma mark - VAN Detail Table Delegate's Delegate Methods


#pragma mark - VAN Tags Table Delegate Delegate Methods

-(void)athleteTagProfileHasBeenUpdated {
    [_tableViewDetailDelegate updateAthleteTagsCellWithAthlete:nil];
}

-(void)VANAddTagCellBecameFirstResponder {
    [self adjustContentInsetsForEditing:YES];
}

-(void)VANAddTagCellIsReleasingFirstResponder {
    [self adjustContentInsetsForEditing:NO];
}


#pragma mark - Tab Bar Delegate Methods

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //A. Will Deselect active cell before animating and record its Name Value to find and reselect afterwards
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    [methods saveManagedObject:self.event];
    
    switch (item.tag) {
        case 0:
            [self sortAthletesByName];
            break;
        case 1:
            [self sortAthletesByNumber];
            break;
        case 2:
            [self sortAthletesBySeen];
            break;
        case 3:
            [self sortAthletesByPosition];
            break;
        case 4:
            [self sortAthletesByFlagged];
            self.currentFlagged = 0;
            item.badgeValue = nil;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - VAN Athlete Image Profile Cell Delegate Methods

-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell
{
    if (!self.pictureTaker) {
        self.pictureTaker = [[VANPictureTaker alloc] init];
        self.pictureTaker.delegate = self;
    }
    [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
}

- (void)VANTableViewCellrequestsImageInFullScreen:(UIImage *)image fromCell:(VANAthleteProfileCell *)cell
{
    NSLog(@"Requesting Full Screen");
    
    [self.tableViewDetail setContentOffset:CGPointMake(0, -104)];
    
    CGPoint offset = cell.imageScrollView.contentOffset;
    CGFloat imageNumber = offset.x/cell.imageScrollView.frame.size.width;
    NSArray *images = [self.athlete.images allObjects];
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
    NSLog(@"Delete Image");
}

-(void)closeSoloImageViewer {
    NSLog(@"Close Solo Image Viewer");
}

#pragma mark - VAN Picture Taker Deletage Methods

-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passBackSelectedImageData:(NSData *)imageData
{
    //It Passes back our ImageData to us, now we do what we wish with it
    
    //A. Send it to Our Table View cell to display
    VANAthleteProfileCell *cell =  (VANAthleteProfileCell *)[self.tableViewDetail cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell addNewImageFromData:imageData];
    
    //B. Create a new Image object and attach it to our selected athlete.
    Athlete *selectedAthlete = _tableViewDetailDelegate.athlete;
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    
    Image *newImage = (Image *)[methods addNewRelationship:rAthleteImages toManagedObject:selectedAthlete andSave:NO];
    newImage.headShot = imageData;
    
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
    VANAthleteEditControllerPad *controller;
    if ([segue.identifier isEqualToString:@"toNewAthletePage"]) {
        NSString *device = [[UIDevice currentDevice] model];
        if ([device isEqualToString:@"iPad"] || [device isEqualToString:@"iPad Simulator"]) {
            UINavigationController *nav = segue.destinationViewController;
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.navigationBar.tintColor = [self.teamColor findTeamColor];
            controller = (VANAthleteEditControllerPad *)[nav topViewController];
            controller.controller = self;
            controller.event = self.event;
        } else {
            controller = segue.destinationViewController;
        }
        controller.athlete = sender;
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
