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


@interface VANAthleteListViewController ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
-(void)cancel;

@end

@implementation VANAthleteListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.teamColor = [[VANTeamColor alloc] init];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    
    [self sortAthleteListbyName]; //Create Original Sort Method, sorted by their name and places them in self.athleteList
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.athleteList count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    VANAthleteListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Athlete *athlete = [self.athleteList objectAtIndex:[indexPath row]];

    [self setupAthleteListCell:cell withAthlete:athlete forIndexPath:indexPath];
    
    return cell;
}

- (void)setupAthleteListCell:(VANAthleteListCell *)cell withAthlete:(Athlete *)athlete forIndexPath:(NSIndexPath *)indexPath
{
    // Method used to set up all cell data that applys to all devices
    [cell initializer];
    cell.delegate = self;
    
    cell.name.text = athlete.name;
    cell.aNumber.text = [athlete.number stringValue];
    cell.isFlagged = [athlete.flagged boolValue];

    //Setting up HeadShotImage:
    cell.athleteHeadshot.layer.cornerRadius = cell.athleteHeadshot.frame.size.height/2;
    cell.athleteHeadshot.layer.masksToBounds = YES;
    cell.athleteHeadshot.backgroundColor = [UIColor lightGrayColor];
    
    //Set up Number
    NSString *athleteNumber = [NSString stringWithFormat:@"%@", athlete.number];
    cell.aNumber.text = athleteNumber;
    cell.aNumberImg.text = athleteNumber;
    
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
        NSPersistentStoreCoordinator *coordinator = [athlete.managedObjectContext persistentStoreCoordinator];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSIndexPath *path = indexPath;
            NSManagedObjectContext *backupContext = [[NSManagedObjectContext alloc] init];
            [backupContext setPersistentStoreCoordinator:coordinator];
            Athlete *backgroundAthlete = (Athlete *)[backupContext objectWithID:athleteID];
            Image *coreImage = backgroundAthlete.profileImage;
            NSData *imageData = coreImage.headShot;
            UIImage *athleteImage = [UIImage imageWithData:imageData];
            [self.imageCache setValue:athleteImage forKey:backgroundAthlete.name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                VANAthleteListCell *imgCell = (VANAthleteListCell *)[self.tableView cellForRowAtIndexPath:path];
                imgCell.athleteHeadshot.image = athleteImage;
            });
            
        });
        /*
        //Set the Images
        Image *coreImage = [[athlete.headShotImage allObjects] objectAtIndex:0];
        NSData *imageData = coreImage.headShot;
        UIImage *athleteImage = [UIImage imageWithData:imageData];
        cell.athleteHeadshot.image = athleteImage;
        */
        [self setNumberWithHeadshotForCell:cell];
        
    } else {
        cell.athleteHeadshot.image = nil; //Cancel for reusable cells
        
        [self setNumberWithoutHeadshotForCell:cell];
        
    }
    
    //Athlete Number and Team Number and its background
    if ([athlete.teamSelected integerValue] > 0) {
        cell.numberBG.backgroundColor = [self.teamColor findTeamColor];
        cell.teamLabel.text = [NSString stringWithFormat:@"Team %@", athlete.teamSelected];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
        [methods removeRelationshipObjectInIndexPath:indexPath forKey:@"athletes"];
        NSMutableSet *athleteSet = [self.event mutableSetValueForKey:@"athletes"];
        self.athleteList = (NSMutableArray *)[athleteSet allObjects];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Athlete *athlete = [self.athleteList objectAtIndex:[indexPath row]];
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
    switch (item.tag) {
        case 0:
            NSLog(@"Sort By Name %ld", (long)item.tag);
            [self sortAthleteListbyName];
            break;
        case 1:
            NSLog(@"Sort By Number");
            [self sortAthleteListbyNumber];
            break;
        case 2:
            NSLog(@"Sort By Seen");
            [self sortAthleteListbySeen];
            break;
        case 3:
            NSLog(@"Sort By Position");
            break;
        case 4:
            NSLog(@"Sort By Flagged");
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}


#pragma mark - Button Press Methods and Pepare for Segue

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewAthlete:(id)sender {
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Athlete *athlete = (Athlete *)[methods addNewRelationship:athleteRelationship toManagedObject:self.event andSave:NO];
    athlete.number = [NSNumber numberWithInteger:[self.event.athletes count]];
    athlete.seen = 0;
    athlete.flagged = 0;
    [self performSegueWithIdentifier:@"toNewAthletePage" sender:athlete];
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
        viewController.athlete = sender;
        viewController.event = self.event;
    }
}

#pragma  mark - Sort Athelte List Methods

-(void)sortAthleteListbyName {
    NSArray *array = [self.event.athletes allObjects];
    NSSortDescriptor *sortByFirst = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.athleteList = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortByFirst]];
}

-(void)sortAthleteListbyNumber {
    NSArray *array = [self.event.athletes allObjects];
    NSSortDescriptor *sortByFirst = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    NSSortDescriptor *sortBySecond = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.athleteList = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortByFirst,sortBySecond]];
}

-(void)sortAthleteListbySeen {
    NSArray *array = [self.event.athletes allObjects];
    NSSortDescriptor *sortByFirst = [NSSortDescriptor sortDescriptorWithKey:@"seen" ascending:YES];
    NSSortDescriptor *sortBySecond = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    self.athleteList = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortByFirst,sortBySecond]];
}

-(void)sortAthleteListbyPosition {
    NSArray *array = [self.event.athletes allObjects];
    NSSortDescriptor *sortByFirst = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    NSSortDescriptor *sortBySecond = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    self.athleteList = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortByFirst,sortBySecond]];
}

-(void)sortAthleteListbyFlagged {
    NSArray *array = [self.event.athletes allObjects];
    NSSortDescriptor *sortByFirst = [NSSortDescriptor sortDescriptorWithKey:@"flagged" ascending:YES];
    NSSortDescriptor *sortBySecond = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    self.athleteList = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortByFirst,sortBySecond]];
}

#pragma mark - VANAthleteListCell Delegate Methods


-(void)swipeTableViewCell:(VANAthleteListCell *)cell didEndSwipingSwipingWithState:(swipeTableViewCellState)state mode:(swipeTableViewCellMode)mode {
    
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

-(void)removeImagesFromProfileCache:(NSArray *)images {
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