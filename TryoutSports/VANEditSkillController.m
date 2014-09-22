//
//  VANEditSkillController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-19.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANEditSkillController.h"
#import "VANEditConfig.h"


static NSString *const kTestKey = @"Tests";
static NSString *const kSkillsKey = @"Skills";
static NSString *const kPositionsKey = @"Positions";


@interface VANEditSkillController ()

@property (nonatomic) VANEditConfig *config;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
-(void)save;
-(void)cancel;
@end


/** -----------------------
self.config.optionIndex Explained:
 
 If optionIndex == 0 : Page is Customized towards Postions
 If optionIndex == 1 : Page is Customized towards Skills
 If optionIndex == 2 : Page is Customized towards Tests

 Passed to Config Object to hide messy code from View Controller
--------------------------- */


@implementation VANEditSkillController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    VANTeamColor *teamColor = [[VANTeamColor alloc]init];
    self.colorView.backgroundColor = [teamColor findTeamColor];
    self.skillOrTest.clearButtonMode = UITextFieldViewModeAlways;
    self.skillOrTest.autocapitalizationType = UITextAutocapitalizationTypeWords;
   // [self.skillOrTest becomeFirstResponder];
    self.skillOrTest.placeholder = @"Type Here";
    if (self.skill == nil && self.position == nil) {
        self.textLabel.text = @"New Test:";
        self.skillOrTest.text = self.test.descriptor;
        self.config = [[VANEditConfig alloc] initWithResource:kTestKey];
        self.config.optionIndex = 2;
        
    } else if (self.position == nil){
        self.textLabel.text = @"New Skill:";
        self.skillOrTest.text = self.skill.descriptor;
        self.config = [[VANEditConfig alloc] initWithResource:kSkillsKey];
        self.config.optionIndex = 1;
    } else {
        self.textLabel.text = @"New Position:";
        self.skillOrTest.text = self.position.position;
        self.config = [[VANEditConfig alloc] initWithResource:kPositionsKey];
        self.config.optionIndex = 0;
    }
    self.config.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods



-(void)save {
    if ([self.skillOrTest.text isEqualToString:@""] || self.skillOrTest.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't Save Empty String" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        if (self.skill == nil && self.position == nil) {
            self.test.descriptor = self.skillOrTest.text;
            [VANGlobalMethods saveManagedObject:self.test];
            NSMutableArray *array = [self.config getPlistFileForResource:kTestKey];
            if (self.config.optionsArray == nil) {
                self.config.optionsArray = [[NSMutableArray alloc] initWithObjects:self.skillOrTest.text, nil];
            } else {
                BOOL doesNotExist = [self.config searchPlistArray:array forItem:self.skillOrTest.text];
                if (doesNotExist) {
                    [self.config.optionsArray addObject:self.skillOrTest.text];
                }
            }
            [self.config saveFileForFilePath:kTestKey];
        
        } else if (self.position == nil){

            [self.skill setValue:self.skillOrTest.text forKey:@"descriptor"];
            [VANGlobalMethods saveManagedObject:self.skill];
            NSMutableArray *array = [self.config getPlistFileForResource:kSkillsKey];
            if (self.config.optionsArray == nil) {
                self.config.optionsArray = [[NSMutableArray alloc] initWithObjects:self.skillOrTest.text, nil];
            } else {
                BOOL doesNotExist = [self.config searchPlistArray:array forItem:self.skillOrTest.text];
                if (doesNotExist) {
                    [self.config.optionsArray addObject:self.skillOrTest.text];
                }
            }
            [self.config saveFileForFilePath:kSkillsKey];

        } else {

            [self.position setValue:self.skillOrTest.text forKey:@"position"];
            [VANGlobalMethods saveManagedObject:self.position];
            NSMutableArray *array = [self.config getPlistFileForResource:kPositionsKey];
            if (self.config.optionsArray == nil) {
                self.config.optionsArray = [[NSMutableArray alloc] initWithObjects:self.skillOrTest.text, nil];
            } else {
                BOOL doesNotExist = [self.config searchPlistArray:array forItem:self.skillOrTest.text];
                if (doesNotExist) {
                    [self.config.optionsArray addObject:self.skillOrTest.text];
                }
            }
            [self.config saveFileForFilePath:kPositionsKey];
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)cancel {
    if (!self.editing) {
        [self.position.managedObjectContext deleteObject:self.position];
        [self.test.managedObjectContext deleteObject:self.test];
        [self.skill.managedObjectContext deleteObject:self.skill];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)[self.config.optionsArray count]);

    return [self.config.optionsArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.config.optionsArray objectAtIndex:[indexPath row]];
    BOOL addAccessory = [self.config shouldAddCellAccessoryforString:cell.textLabel.text];
    if (addAccessory) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        self.skillOrTest.text = [self.config.optionsArray objectAtIndex:indexPath.row];
        [self save];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Popular:";
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.config.optionsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        
    }
}

#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"Pressing Return");
    [self save];
    return YES;
}

@end
