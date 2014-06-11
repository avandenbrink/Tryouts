//
//  VANMainMenuViewControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMainMenuViewControllerPad.h"
#import "VANAthleteDetailControllerPad.h"
#import "VANSettingTabsControllerPad.h"
#import "VANIntroViewControllerPad.h"
#import "VANAthleteListControllerPad.h"
#import "VANAthleteSignInController.h"

//Static Strings for Actions to be taken based on notficationes pressed.

static NSString *nValue = @"value";
static NSString *nImportance = @"importance";
static NSString *nAction = @"action";

static NSString const *kToSettings = @"settings";
static NSString const *kToTeamView = @"team";
static NSString const *kToAthleteListFlagged = @"flagged";
static NSString const *kToAthleteListUnseen = @"unseen";

static NSInteger logoBGCornerRadus = 105;
static NSInteger logoCornerRadius = 100;

@interface VANMainMenuViewControllerPad ()

@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation VANMainMenuViewControllerPad

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //On First Load, Build notifications for the Table View Based on current event state
    VANTeamColor *color = [[VANTeamColor alloc] init];
    
    _logoSeparator.backgroundColor = [color findTeamColor];
    _logoBGView.backgroundColor = [color findTeamColor];
    _logoBGView.layer.masksToBounds = YES;
    _logoBGView.layer.cornerRadius = logoBGCornerRadus;
    
    _logo.layer.masksToBounds = YES;
    _logo.layer.cornerRadius = logoCornerRadius;
    _logo.backgroundColor = [UIColor whiteColor];
    
    if (self.event.logo) {
        NSData *imageData = self.event.logo;
        UIImage *image = [UIImage imageWithData:imageData];
        _logo.image = image;
    } else {
        UIButton *button = [[UIButton alloc] initWithFrame:_logo.frame];
        [_logoBGView addSubview:button];
        [button addTarget:self action:@selector(pickOrTakePicture) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = logoCornerRadius;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Place any code that needs to be updated when Settings are released Here ---->
    self.navigationItem.title = self.event.name;
    [self buildNotifications];
    [self.notificationTable reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewAthletes"]) {
        UINavigationController *nav = [segue destinationViewController];
        UISplitViewController *split = (UISplitViewController *)[nav topViewController];
        UINavigationController *nav1 = [split.viewControllers objectAtIndex:0];
        VANAthleteListViewController *controller = (VANAthleteListViewController *)[nav1 topViewController];
        controller.event = self.event;
        UINavigationController *nav2 = [split.viewControllers objectAtIndex:1];
        VANAthleteDetailControllerPad *detailController = (VANAthleteDetailControllerPad *)[nav2 topViewController];
        detailController.delegate = self;
        detailController.event = self.event;
        
    } if ([segue.identifier isEqualToString:@"toEventSettings"]) {
        VANFullNavigationViewController *nav = segue.destinationViewController;
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        VANSettingTabsControllerPad *tabBarController = (VANSettingTabsControllerPad *)nav.topViewController;
        tabBarController.delegate = tabBarController;
        tabBarController.superView = self;
        // Temporarily decreasing Event Teams to account for 0 being no team. Will be added back when view disappears
        self.event.numTeams = [NSNumber numberWithInt:[self.event.numTeams intValue]-1];
        tabBarController.event = self.event;
        tabBarController.selectedIndex = 0;
        VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
        controller.event = self.event;
    }else if ([segue.identifier isEqualToString:@"toEventPicker"]){
        NSLog(@"To Event Picker");
        UINavigationController *nav = [segue destinationViewController];
        VANIntroViewControllerPad *controller = (VANIntroViewControllerPad *)[nav topViewController];
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"toAthleteList"]) {
        VANAthleteListControllerPad *controller = segue.destinationViewController;
        controller.tabBar.selectedItem = [controller.tabBar.items objectAtIndex:0];
        controller.event = self.event;
    } else if ([segue.identifier isEqualToString:@"toAthleteSignIn"]) {
        VANAthleteSignInController *controller = segue.destinationViewController;
        controller.event = self.event;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)releaseAthleteDetailViews {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Data Source Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_notifications count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dic = [_notifications objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic valueForKey:nValue];
    NSNumber *imp = [dic valueForKey:nImportance];
    NSInteger i = [imp integerValue];
    if (i == VANNotificationImportanceDone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (i == VANNotificationImportanceError) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (i == VANNotificationImportanceWarning) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Notifications";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

#pragma mark - TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_notifications objectAtIndex:indexPath.row];
    NSNumber *number = [dic valueForKey:nAction];
    if ([number integerValue] == VANNotificationActionToAthletes) {
        [self performSegueWithIdentifier:@"toAthleteList" sender:self.event];
    }
    
    
}

#pragma mark - Action Sheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Aaron V");
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Button Pressed Methods

-(void)toAthleteSignIn:(id)sender
{
    [self performSegueWithIdentifier:@"toAthleteSignIn" sender:nil];
}

#pragma mark - Custom Methods for Notifications

-(void)pickOrTakePicture {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Image From:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Pick From Library" otherButtonTitles:@"Take a Picture", nil];
    [action showFromRect:_logoBGView.frame inView:self.view animated:YES];
}

-(void)buildNotifications
{
    _notifications = nil;
    //Ensure that notifications array is created
    if (!_notifications) {
        _notifications = [[NSMutableArray alloc] init];
    }
    
    // --------------
    //Simplified Notification Requests based on the current state of the Event
    //AKA if there are no athletes yet we don't need to notify that teams are empty
    // --------------
    
    //Notifications Dealing with Event Information -----------
    (!self.event.name) ? [self addNotificationAlertForValue:@"Missing event name" importance:VANNotificationImportanceError action:VANNotificationActionToSettings]:nil;
    
    (!self.event.location) ? [self addNotificationAlertForValue:@"Missing event location" importance:VANNotificationImportanceNeutral action:VANNotificationActionToSettings]:nil;
    
    
    //Notifications dealing with teams and athletes ----------
    if ([self.event.athletes count] < 1) { // If there are no athlete profiles yet...
        [self addNotificationAlertForValue:@"No athlete profiles yet" importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletes];
    } else { // If we do have athletes created:
        
        
        // ----- If there are athlete profiles that have not yet been seen
        NSArray *seen = [self fetchAthletesWithValuePredicate:@"seen" thatIsBool:NO];
        if ([seen count] == 1) {
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu unseen athlete profile", (unsigned long)[seen count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletesSeen];
        } else if(seen) { //Plural for Grammar's Sake
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu unseen athlete profiles", (unsigned long)[seen count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletesSeen];
        }
        
        // ------ If there are athelte profiles that are flagged
        NSArray *flagged = [self fetchAthletesWithValuePredicate:@"flagged" thatIsBool:YES];
        if ([flagged count] == 1) {
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu flagged athlete profile", (unsigned long)[seen count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletesFlagged];
        } else if(flagged) { //Plural for Grammar's Sake
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu flagged athlete profiles", (unsigned long)[seen count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletesFlagged];
        }
        
        // Warning an athlete(s) is registered to a team that no longer exists ------
        // Only happens when Athlete is given a team then the number of teams are changed
        NSNumber *teamCount = self.event.numTeams;
        NSArray *athletesOver = [self fetchAthletesWithPredicateValue:@"teamSelected" greatThan:teamCount];
        if ([athletesOver count] == 1) {
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu athlete is on a team that no longer exists", (unsigned long)[athletesOver count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletes];
        } else if (athletesOver) {
            [self addNotificationAlertForValue:[NSString stringWithFormat:@"%lu athletes on a team that no longer exists", (unsigned long)[athletesOver count]] importance:VANNotificationImportanceWarning action:VANNotificationActionToAthletes];
        }
        
        // Team X only has y number of players.
        
        // Team x Doesn't have any athletes with x position.
        
    }
    
    //Notifications dealing with athlete signup and
    
    
    // You Have Athletes that have checked in but are not confirmed
    // You have athletes that are on the list but have not checked in
    // If Athlete Information is being used: Some of your Athletes do not have a phone number registered, some of your athletes do not have a email registered.
    
    //If Settings are changed after some editing has occured:
    //
    
}

- (void)addNotificationAlertForValue:(NSString *)value importance:(VANNotificationImportance)importance action:(VANNotificationAction)action
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[value, [NSNumber numberWithInteger:importance], [NSNumber numberWithInteger:action]] forKeys:@[nValue, nImportance, nAction]];
    [_notifications addObject:dic];
}

-(NSArray *)fetchAthletesWithValuePredicate:(NSString *)predicate thatIsBool:(BOOL)boolian
{
    NSManagedObjectContext *context = [self.event managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Athlete" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %hhd", predicate, boolian]];
    [request setPredicate:filterPredicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (!array || [array count] < 1) {
        return nil;
    }
    return  array;
}

-(NSArray *)fetchAthletesWithPredicateValue:(NSString *)predicate greatThan:(NSNumber *)number
{
    NSManagedObjectContext *context = [self.event managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Athlete" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ > %@", predicate, number]];
    [request setPredicate:filterPredicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (!array || [array count] < 1) {
        return nil;
    }
    return  array;
}

@end
