//
//  VANAppSettingsViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAppSettingsViewController.h"
#import "VANIntroViewController.h"
#import "VANTeamColor.h"

@interface VANAppSettingsViewController ()

@end

@implementation VANAppSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshFields];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:app];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshFields];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.navigationController.navigationBar setTintColor:[teamColor findTeamColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.clubName.text = [defaults objectForKey:kClubName];
    switch ([defaults integerForKey:kTeamColor]) {
        case 0:
            self.teamColor.text = @"Default";
            break;
        case 1:
            self.teamColor.text = @"Royal Blue";
            break;
        case 2:
            self.teamColor.text = @"Navy Blue";
            break;
        case 3:
            self.teamColor.text = @"Sky Blue";
            break;
        case 4:
            self.teamColor.text = @"Shamrock Green";
            break;
        case 5:
            self.teamColor.text = @"Forest Green";
            break;
        case 6:
            self.teamColor.text = @"Lime Green";
            break;
        case 7:
            self.teamColor.text = @"Scarlet Red";
            break;
        case 8:
            self.teamColor.text = @"Maroon Red";
            break;
        case 9:
            self.teamColor.text = @"Orange";
            break;
        case 10:
            self.teamColor.text = @"Yellow";
            break;
        case 11:
            self.teamColor.text = @"Golden Yellow";
            break;
        case 12:
            self.teamColor.text = @"Purple";
            break;
        case 13:
            self.teamColor.text = @"Pink";
            break;
        default:
            break;
    }
    self.webURL.text = [defaults objectForKey:kWebsite];
}

- (IBAction)clubNameEdited:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.clubName.text forKey:kClubName];
    [defaults synchronize];
    [sender resignFirstResponder];
}

- (IBAction)clubWebsiteEdited:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.webURL.text forKey:kWebsite];
    [defaults synchronize];
    [sender resignFirstResponder];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [self refreshFields];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [self.clubName resignFirstResponder];
    [self.webURL resignFirstResponder];
}

#pragma mark - Actions

-(IBAction)done:(id)sender {
    [self.delegate appSettingsViewControllerDidFinish:self];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self deleteTagsPlist];
    }
}

- (NSString *)dataFilePathforPath:(NSString *)string {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:string];
}

-(void)deleteTagsPlist {
    NSString *dataPath = @"tags.plist";
    NSString *filePath = [self dataFilePathforPath:dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"CharacteristicsDefault" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"Characteristics"]];
        NSLog(@"Rebuilding tags.plist");
        [array writeToFile:filePath atomically:YES];
    } else {
        NSLog(@"File Path Doesn't Yet Exists");
    }
}
/*
-(void)teamColorChangerViewControllerDidFinish:(VANTeamColorChangerViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self refreshFields];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"changeColor"]) {
        //[[segue destinationViewController] setDelegate:self];
    }
}


@end
