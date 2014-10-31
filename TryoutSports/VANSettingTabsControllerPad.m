//
//  VANSettingsTabsControllerPAD.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-26.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANSettingTabsControllerPad.h"
#import "VANMainMenuViewControllerPad.h"

@interface VANSettingTabsControllerPad ()

@end

@implementation VANSettingTabsControllerPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel {
    if (![self.superView isKindOfClass:[VANMainMenuViewController class]]) {
        NSManagedObjectContext *context = [self.event managedObjectContext];
        [context deleteObject:self.event];
    }
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

-(void)saveEvent:(id)sender {
    [self.view endEditing:YES];
    
    //Checks to ensure that the Name quality is not Empty
    if (self.event.name == nil || [self.event.name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Missing" message:@"Your Event must have a name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self saveManagedObjectContext:self.event];
        [self.superView viewWillAppear:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
