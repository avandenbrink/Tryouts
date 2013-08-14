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

@interface VANAthleteListViewController ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
-(void)cancel;
@end

@implementation VANAthleteListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.athleteList = (NSMutableArray *)[self.event.athletes allObjects];
}

-(void)viewWillAppear:(BOOL)animated {
    self.athleteList = (NSMutableArray *)[self.event.athletes allObjects];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
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
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];

    // Configure the cell...
    Athlete *athlete = [self.athleteList objectAtIndex:[indexPath row]];
    
    cell.name.text = athlete.name;
    
    cell.aNumber.text = [athlete.number stringValue];
    cell.numberBG.layer.cornerRadius = 20.0;
    cell.numberBG.backgroundColor = [UIColor darkGrayColor];
    
    
    //Set Up the Headshot or Image for the athlete
    cell.athleteHeadshot.backgroundColor = [teamColor findTeamColor];
//    NSLog(@"Athlete Has %lu headshots", (unsigned long)[athlete.headShotImage count]);
    if ([athlete.headShotImage count] > 0) {
        NSLog(@"Trying to Register Pictures for Athlete Cell");
        Image *imageMO = [[athlete.headShotImage allObjects] objectAtIndex:0];
        UIImage *image = [UIImage imageWithData:imageMO.headShot];
        cell.athleteHeadshot.image = image;
    } else {
        cell.athleteHeadshot.image = nil;
    }
    cell.athleteHeadshot.layer.cornerRadius = 35.0;
    cell.athleteHeadshot.layer.masksToBounds = YES;
    
    
    //Set up the Image for whether that athlete has been seen
    if ([athlete.seen boolValue] == NO) {
        cell.seenImg.image = [UIImage imageNamed:@"seen.png"];
    } else {
        cell.seenImg.image = nil;
    }
    
    //Set up if athlete is selected to a team
    NSLog(@"Team: %@", athlete.teamSelected);
    if ([athlete.teamSelected integerValue] > 0) {
        NSLog(@"Selected to Team: %@", athlete.teamSelected);
        cell.teamBG.layer.cornerRadius = 5.0;
        cell.teamLabel.text = [NSString stringWithFormat:@"%@", athlete.teamSelected];
        cell.teamNameLabel.text = @"Team";
        if ([athlete.teamSelected integerValue] > [self.event.numTeams integerValue]) {
            cell.teamBG.backgroundColor = [UIColor redColor];
        } else {
            cell.teamBG.backgroundColor = [teamColor findTeamColor];
        }
    } else {
        cell.teamBG.backgroundColor = [UIColor clearColor];
        cell.teamLabel.text = @"";
        cell.teamNameLabel.text = @"";
    }
    
    //Setting up the custom Highlight Color;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    backgroundView.backgroundColor = [teamColor washedColor];
    cell.selectedBackgroundView = backgroundView;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removeRelationshipObjectInIndexPath:indexPath forKey:@"athletes"];
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
    NSManagedObject *athlete = [self.athleteList objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"toAthleteDetail" sender:athlete];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


#pragma  mark - Cutsom Methods

- (IBAction)addNewAthlete:(id)sender {
    Athlete *athlete = (Athlete *)[self addNewRelationship:athleteRelationship toManagedObject:self.event andSave:NO];
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
        VANNewAthleteController *viewController = segue.destinationViewController;
        viewController.athlete = sender;
        viewController.event = self.event;
    }
}

@end