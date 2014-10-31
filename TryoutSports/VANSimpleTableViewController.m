//
//  VANSimpleTableViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANSimpleTableViewController.h"

static NSString *kHeaderTitle = @"headerTitle";
static NSString *kHeaderView = @"headerView";
static NSString *kMessage = @"message";
static NSString *kInstructions = @"instructions";

@interface VANSimpleTableViewController ()

@property (strong, nonatomic) NSMutableData *valueUpdates;

@end

@implementation VANSimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = [self.elements valueForKey:kInstructions];
    self.instructions.text = text;
    UIFont *font = self.instructions.font;
    self.instructions.font = [font fontWithSize:18];
    
    if (self.tableDelegate) {
        self.table.delegate = self.tableDelegate;
        self.table.dataSource = self.tableDelegate;
    } else {
        self.table.delegate = self.tableDelegate;
        self.table.dataSource = self.tableDelegate;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.canSkip && self.values.count == 0) {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:NO];
    } else if (self.values.count > 0) {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:YES];
    } else {
        [self.delegate updateForwardButtonToTitle:@"Skip" isActive:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger add = (self.showAddMore) ? 1 : 0;
    return [self.values count]+add;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.values objectAtIndex:section];
    NSInteger add = (self.showAddMore) ? 1 : 0;
    return [array count]+add;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showAddMore && indexPath.row == [self.values count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
        }
        cell.textLabel.text = @"Add another";
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}


#pragma mark - Table View Delegate Methods

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *view = [self.elements valueForKey:kHeaderTitle];
    return [view objectAtIndex:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSArray *view = [self.elements valueForKey:kMessage];
    return [view objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *view = [self.elements valueForKey:kHeaderView];
    if (view.count > 0) {
        return [view objectAtIndex:section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Interview Table View Delegate Methods 

-(void)hasInteractedWithTableView {
    if (!self.hasBeenTouched) {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:YES];
        self.hasBeenTouched = YES;
    }
}

#pragma mark - Superclass Controller Methods

-(void)prepareToResignSpotlight {
    if (self.tableDelegate) {
        [self.tableDelegate collectValuesFromTable];
    }
}

-(BOOL)canPrepareToMoveForward {
    [self.view endEditing:YES];
    BOOL value = [self.tableDelegate canPrepareToMoveForward];
    if (!value) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Value" message:@"One or more of the values inputed on this page is missing. Add a value or remove the page" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return value;
}


@end
