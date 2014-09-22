//
//  VANAthleteListViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteListViewController.h"
#import "VANMainMenuViewController.h"
#import "VANAthleteDetailController.h"
#import "VANAthleteListCell.h"
#import "VANTeamColor.h"
#import "Image.h"
#import "VANGlobalMethods.h"


static NSString *kUserSettingSortType = @"AhleteListFilterType";

@interface VANAthleteListViewController ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
-(void)cancel;

@end

@implementation VANAthleteListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.teamColor = [[VANTeamColor alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger tabIndex = [[defaults valueForKey:kUserSettingSortType] integerValue];
    if (tabIndex == NSNotFound) {
        tabIndex = 0;
    }
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:tabIndex];
    [self sortAthletesByIndex:tabIndex];
    
    self.imageCache = [NSMutableDictionary dictionary]; //Create the Image Cache Dictionary for future use.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_shouldReloadCache) {
        [self removeImagesFromProfileCache:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self tabBar:self.tabBar didSelectItem:self.tabBar.selectedItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.imageCache = nil; //Dispose of the Image Data that is Cached
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:section]];
    return [array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VANAthleteListCell *cell = (VANAthleteListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];

    [self setupAthleteListCell:cell withAthlete:athlete forIndexPath:indexPath];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
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

- (void)setupAthleteListCell:(VANAthleteListCell *)cell withAthlete:(Athlete *)athlete forIndexPath:(NSIndexPath *)indexPath
{
    // Method used to set up all cell data that applys to all devices
    [cell initializer];
    cell.delegate = self;
    
    cell.name.text = athlete.name;
    cell.aNumber.text = [athlete.number stringValue];
    cell.isFlagged = [athlete.flagged boolValue];

    cell.athleteHeadshot.layer.masksToBounds = YES;
    cell.athleteHeadshot.backgroundColor = [UIColor lightGrayColor];
    
    //Set up Number
    cell.aNumber.text = [athlete.number stringValue];
    cell.aNumberImg.text = [athlete.number stringValue];
    
    
    if (athlete.images.count > 0 && !athlete.profileImage) {
        athlete.profileImage = [[athlete.images allObjects] firstObject];
    }
    //Athlete Image + Number + Team more
    //If we have Images that are associated with an Athlete, then we will place those in the headShotImageView and will make other plans for the number of the athlete.
    //Alternatively if the Athlete does not have any images yet, the space will be taken up with the Athlete's number
    if([self.imageCache valueForKey:athlete.name]) {
        
        //If Image is already loaded in Cache
        cell.athleteHeadshot.image = [self.imageCache valueForKey:athlete.name];
        
        [self setNumberWithHeadshotForCell:cell];
        
    } else if (athlete.profileImage) {
        //If images are available but not loaded in cache yet
            //Convert this to Background Thread Work !!!!!!!!!! ------------------------------
        NSManagedObjectID *athleteID = athlete.objectID;
        NSManagedObjectContext *parent = athlete.managedObjectContext.parentContext;
        [parent performBlock:^{
            NSIndexPath *path = indexPath;
            Athlete *bgAthlete = (Athlete *)[parent objectWithID:athleteID];
            Image *coreImage = bgAthlete.profileImage;
            NSData *imageData = coreImage.headShot;
            UIImage *athleteImage = [UIImage imageWithData:imageData];
            [self.imageCache setValue:athleteImage forKey:bgAthlete.name];
            [bgAthlete.managedObjectContext performBlock:^{
                VANAthleteListCell *imgCell = (VANAthleteListCell *)[self.tableView cellForRowAtIndexPath:path];
                imgCell.athleteHeadshot.image = athleteImage;
            }];
        }];
        [self setNumberWithHeadshotForCell:cell];
    } else {
        cell.athleteHeadshot.image = nil; //Cancel for reusable cells
        
        [self setNumberWithoutHeadshotForCell:cell];
        
    }
    
    //Athlete Number and Team Number and its background
    if (athlete.teamName) {
        cell.numberBG.backgroundColor = [self.teamColor findTeamColor];
        cell.teamLabel.text = [NSString stringWithFormat:@"%@", athlete.teamName.name];
        cell.athleteHeadshot.backgroundColor = [self.teamColor washedColor];
    } else {
        cell.numberBG.backgroundColor = [UIColor lightGrayColor];
        cell.teamLabel.text = @"";
    }
    
    //If the Athlete hasn't been seen then add the Seen icon.
    if ([athlete.seen boolValue] == NO) {
        cell.seenImg.image = [UIImage imageNamed:@"TSsmall-02.png"];
    } else {
        cell.seenImg.image = nil;
    }
    //Overriding the seen image, if the athlete is flagged then change the Seen icon (or no icon) to the flagged option.
    if ([athlete.flagged boolValue] == YES) {
        cell.seenImg.image = [UIImage imageNamed:@"TSsmall-05.png"];
    } // Can't use an 'else' otherwise it will erase Seen Bool's setting. if both seen and flagged are No then seenImg will be nil already.
}


-(void)setNumberWithHeadshotForCell:(VANAthleteListCell *)cell
{
    cell.numberBG.hidden = NO; // Reveal Number circle in top right corner of headshot img
    cell.numberBG.layer.cornerRadius = cell.numberBG.frame.size.width/2;
    cell.aNumberImg.hidden = YES; //Hide label overtop of headshot image
}


-(void)setNumberWithoutHeadshotForCell:(VANAthleteListCell *)cell
{
    cell.numberBG.hidden = YES; // Hide number view
    cell.aNumberImg.hidden = NO; // Show label above headshot
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.athleteLister valueForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    Athlete *athlete = [array objectAtIndex:indexPath.row];
    if (self.compareDelegate) {
        [self.compareDelegate completeChangeAthlete:athlete];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"toAthleteDetail" sender:athlete];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Tab Bar Delegate Methods


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //A. Will Deselect active cell before animating and record its Name Value to find and reselect afterwards
    [VANGlobalMethods saveManagedObject:self.event];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:item.tag] forKey:kUserSettingSortType];
    [self sortAthletesByIndex:item.tag];
    
    if (item.tag == 4) {
        self.currentFlagged = 0;
        item.badgeValue = nil;
    }
    [self.tableView reloadData];
}

#pragma mark - Button Press Methods and Pepare for Segue

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewAthlete:(id)sender {
    [self performSegueWithIdentifier:@"toNewAthletePage" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAthleteDetail"]) {
        if ([sender isKindOfClass:[NSManagedObject class]]) {
            VANAthleteDetailController *viewController = segue.destinationViewController;
            viewController.athlete = sender;
            viewController.athlete.seen = [NSNumber numberWithInteger:1];
            viewController.event = self.event;
        }
    } else if ([segue.identifier isEqualToString:@"toNewAthletePage"]) {
        VANAthleteEditController *viewController = segue.destinationViewController;
        viewController.event = self.event;
        viewController.delegate = self;
        if (sender) {
            viewController.athlete = sender;
        } else {
            viewController.isNew = YES;
        }
    }
}

#pragma  mark - Sort Athelte List Methods

-(void)sortAthletesByIndex:(NSInteger)index {
    if (index == 0) {
        NSArray *array = [self.event.athletes allObjects];
        self.athleteLister = [NSMutableDictionary dictionary];
        self.sectionArray = [NSMutableArray array];
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByName]];
        for (Athlete *athlete in sortedArray) {
            NSString *name = athlete.name;
            NSString *firstLetter = [name substringToIndex:1];
            if (!firstLetter) {
                firstLetter = @"No Name";
            }
            if (![self.athleteLister objectForKey:firstLetter]) {
                NSMutableArray *array = [NSMutableArray arrayWithObject:athlete];
                [self.athleteLister setValue:array forKey:firstLetter];
                [self.sectionArray addObject:firstLetter];
            } else {
                NSMutableArray *array = [self.athleteLister objectForKey:firstLetter];
                [array addObject:athlete];
            }
        }
    } else if (index == 3) {
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
    } else if (index == 2) {
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
    } else if (index == 1) {
        NSArray *array = [self.event.athletes allObjects];
        self.athleteLister = [NSMutableDictionary dictionary];
        self.sectionArray = [NSMutableArray arrayWithObject:@"Numbers"];
        NSSortDescriptor *sortByNumber = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortByNumber]];
        [self.athleteLister setObject:sortedArray forKey:[self.sectionArray objectAtIndex:0]];
    } else if (index == 4) {
        
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
}

#pragma mark - VANAthleteListCell Delegate Methods

-(void)swipeTableViewCell:(VANAthleteListCell *)cell didEndSwipingSwipingWithState:(swipeTableViewCellState)state mode:(swipeTableViewCellMode)mode
{
    NSManagedObjectContext *context = [self.event managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Athlete" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", cell.name.text];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    Athlete *athlete;
    if ([result count] > 0) {
        athlete = [result objectAtIndex:0];
    } else {
        NSLog(@"Warning No Athlete Found with name: %@, After Swiping Completed", cell.name.text);
        return;
    }
    
    if (state == swipeTableViewCellState1)
    {
        athlete.flagged = [NSNumber numberWithBool:YES];
        cell.seenImg.image = [UIImage imageNamed:@"TSsmall-05.png"];
        self.currentFlagged++;
        cell.isFlagged = YES;
        UITabBarItem *item = [self.tabBar.items objectAtIndex:[self.tabBar.items count]-1];
        item.badgeValue = [NSString stringWithFormat:@"%lu",(long)self.currentFlagged];
    }
    else if (state == swipeTableViewCellState2)
    {
        athlete.flagged = [NSNumber numberWithBool:NO];
        cell.isFlagged = NO;
        
        if (!athlete.seen) {
            cell.seenImg.image = [UIImage imageNamed:@"TSsmall-02.png"];
        } else {
            cell.seenImg.image = nil;
        }
        _currentFlagged--;
        
        if (_currentFlagged < 1) {
            _currentFlagged = 0;
        } else {
            UITabBarItem *item = [self.tabBar.items objectAtIndex:[self.tabBar.items count]-1];
            item.badgeValue = [NSString stringWithFormat:@"%lu",(long)_currentFlagged];
        }
    }
}

#pragma mark - Custom Methods

-(void)removeImagesFromProfileCache:(NSArray *)images
{
    if (!images) {
        _imageCache = nil;
    } else if (_imageCache){
        for (int i = 0; i < [images count]; i++) {
            NSString *name = [images objectAtIndex:i];
            [_imageCache removeObjectForKey:name];
        }
    }
    _shouldReloadCache = NO;
}


@end