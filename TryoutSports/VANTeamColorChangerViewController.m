//
//  VANTeamColorChangerViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-04-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTeamColorChangerViewController.h"
#import "VANIntroViewController.h"
#import "UIColor+NewColors.h"
#import "VANTeamColor.h"

@interface VANTeamColorChangerViewController ()

@property (nonatomic) NSInteger currentColor;
@property (strong, nonatomic) UIColor *teamColor;

@end

@implementation VANTeamColorChangerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Default";
            cell.backgroundColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 1:
            cell.textLabel.text = @"Royal Blue";
            cell.backgroundColor = [UIColor blueColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 2:
            cell.textLabel.text = @"Navy Blue";
            cell.backgroundColor = [UIColor navyBlue];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 3:
            cell.textLabel.text = @"Sky Blue";
            cell.backgroundColor = [UIColor skyBlue];
            break;
        case 4:
            cell.textLabel.text = @"Shamrock Green";
            cell.backgroundColor = [UIColor shamrockGreen];
            break;
        case 5:
            cell.textLabel.text = @"Forest Green";
            cell.backgroundColor = [UIColor forestGreen];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 6:
            cell.textLabel.text = @"Lime Green";
            cell.backgroundColor = [UIColor limeGreen];
            break;
        case 7:
            cell.textLabel.text = @"Scarlet Red";
            cell.backgroundColor = [UIColor redColor];
            break;
        case 8:
            cell.textLabel.text = @"Maroon Red";
            cell.backgroundColor = [UIColor maroonRed];
            break;
        case 9:
            cell.textLabel.text = @"Orange";
            cell.backgroundColor = [UIColor orangeColor];
            break;
        case 10:
            cell.textLabel.text = @"Yellow";
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case 11:
            cell.textLabel.text = @"Golden Yellow";
            cell.backgroundColor = [UIColor goldenYellow];
            break;
        case 12:
            cell.textLabel.text = @"Purple";
            cell.backgroundColor = [UIColor purpleColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 13:
            cell.textLabel.text = @"Pink";
            cell.backgroundColor = [UIColor pinkColor];
            break;
        default:
            break;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger selected = [defaults integerForKey:kTeamColor];
    
    if (selected == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentColor = indexPath.row;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:self.currentColor inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _currentColor = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:indexPath.row forKey:kTeamColor];
    [defaults synchronize];
    
    switch (indexPath.row) {
        case 0:
            self.teamColor = [UIColor blackColor];
            break;
        case 1:
            self.teamColor = [UIColor blueColor];
            break;
        case 2:
            self.teamColor = [UIColor navyBlue];
            break;
        case 3:
            self.teamColor = [UIColor skyBlue];
            break;
        case 4:
            self.teamColor = [UIColor shamrockGreen];
            break;
        case 5:
            self.teamColor = [UIColor forestGreen];
            break;
        case 6:
            self.teamColor = [UIColor limeGreen];
            break;
        case 7:
            self.teamColor = [UIColor redColor];
            break;
        case 8:
            self.teamColor = [UIColor maroonRed];
            break;
        case 9:
            self.teamColor = [UIColor orangeColor];
            break;
        case 10:
            self.teamColor = [UIColor yellowColor];
            break;
        case 11:
            self.teamColor = [UIColor goldenYellow];
            break;
        case 12:
            self.teamColor = [UIColor purpleColor];
            break;
        case 13:
            self.teamColor = [UIColor pinkColor];
            break;
            
        default:
            self.teamColor = [UIColor blackColor];
            break;
    }
    [self.navigationController.navigationBar setTintColor:self.teamColor];
    [self.navigationController popViewControllerAnimated:YES];
    //[self.delegate teamColorChangerViewControllerDidFinish:self];

}

- (IBAction)confirmColorChange:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.delegate teamColorChangerViewControllerDidFinish:self];
}

@end
