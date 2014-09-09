//
//  VANIntroViewControllerPAD.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewControllerPad.h"
#import "VANSettingTabsControllerPad.h"

static NSInteger logoWidth = 300;
static NSInteger tableWidth = 400;
static NSInteger tableHeight = 400;
static NSInteger marginSpacing = 100;

static NSInteger popoverWidth = 300;
static NSInteger popoverMargins = 3;
static NSInteger popoverElementHeight = 50;

static NSString* const fileNameType = @".tryoutsports";
static NSString* const managedObjectEvent = @"Event";

@interface VANIntroViewControllerPad ()

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UITextField *nameText;

@property (nonatomic) BOOL newLoad; //For Intro Animation

@end

@implementation VANIntroViewControllerPad

@synthesize fileList = _fileList;

- (NSURL*)containerURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [[NSFileManager defaultManager]
               URLForUbiquityContainerIdentifier:nil];
    });
    return url;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.newLoad = YES; //To initiate intro animation
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews {
    if (self.newLoad) {
        CGRect startFromTableFrame = CGRectMake(0,0,0,0);
        CGRect startLogoFrame = CGRectMake(0,0,0,0);
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {

            
            startFromTableFrame = CGRectMake(self.view.frame.size.width, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            startFromTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height, tableWidth, tableHeight);
            startLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        }
        [self.eventsTable setFrame:startFromTableFrame];
        [self.logoImage setFrame:startLogoFrame];
    } else {
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            
            
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.newLoad) {
    //Animate the TableView into view. Simlar to the Dropbox Intro
    [UIView animateWithDuration:1 animations:^{
        CGRect toTableFrame = CGRectMake(0,0,0,0);
        CGRect toLogoFrame = CGRectMake(0,0,0,0);
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
            toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth,logoWidth);
        } else {
            toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
            toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
        }
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
        self.newLoad = NO;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect toTableFrame = CGRectMake(0,0,0,0);
    CGRect toLogoFrame = CGRectMake(0,0,0,0);
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)-marginSpacing, (self.view.frame.size.height-tableHeight)/2, tableWidth, tableHeight);
        toLogoFrame = CGRectMake(((self.view.frame.size.width/2)-logoWidth)/2, (self.view.frame.size.height-logoWidth)/2, logoWidth, logoWidth);
    } else {
        toTableFrame = CGRectMake((self.view.frame.size.width-tableWidth)/2, self.view.frame.size.height-tableHeight-marginSpacing, tableWidth, tableHeight);
        toLogoFrame = CGRectMake((self.view.frame.size.width-logoWidth)/2, (self.view.frame.size.height-logoWidth-tableHeight)/3, logoWidth, logoWidth);
    }
    [UIView animateWithDuration:1 animations:^{
        [self.eventsTable setFrame:toTableFrame];
        [self.logoImage setFrame:toLogoFrame];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAppSettings"]) {
        VANFullNavigationViewController *controller = [segue destinationViewController];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        VANAppSettingsViewController *settingsController = (VANAppSettingsViewController *)[controller topViewController];
        settingsController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"toEventSettings"]) {
        VANFullNavigationViewController *nav = [segue destinationViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        VANSettingTabsControllerPad *tabBarController = (VANSettingTabsControllerPad *)[nav topViewController];
        tabBarController.delegate = tabBarController;
        tabBarController.event = sender;
        tabBarController.selectedIndex = 0;
        VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
        controller.event = tabBarController.event;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - Table View Data Source Methods 

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Existing Events";
}

#pragma mark - Popover View Controller Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

#pragma mark - Create New File
-(void)closePopoverFromSave {
    if ([self.nameText hasText]) {  //If we have a valid Name
        NSString *startingFileName = self.nameText.text;
        //Dismiss Popover
        [self.popover dismissPopoverAnimated:YES];
        self.nameText = nil;

        [self createNewFileWithName:startingFileName];
        
        //        if (self.cloudEnabled) {
        //
        //            NSURL* cloudURL =
        //            [self.containerURL URLByAppendingPathComponent:fileName];
        //
        //            dispatch_queue_t queue =
        //            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //
        //            dispatch_async(queue, ^{
        //
        //                NSError* error;
        //
        //                if (![[NSFileManager defaultManager]
        //                      setUbiquitous:YES
        //                      itemAtURL:documentURL
        //                      destinationURL:cloudURL
        //                      error:&error]) {
        //                    
        //                    [NSException
        //                     raise:NSGenericException
        //                     format:@"Error moving to iCloud container: %@",
        //                     error.localizedDescription];
        //                }
        //                
        //                [self.urlsForFileNames setValue:cloudURL
        //                                         forKey:fileName];
        //                
        //            });
        //        }
        
    } else {
        [self.nameText becomeFirstResponder];
        VANTeamColor *color = [[VANTeamColor alloc] init];
        self.nameText.layer.borderColor = [[color findTeamColor] CGColor];
        self.nameText.borderStyle = UITextBorderStyleLine;
    }
}

-(void)completeNewEventCreationWithEvent:(Event *)event {
    [self performSegueWithIdentifier:@"pushToMain" sender:event];
}

-(void)closeAndCancelPopover {
    [self.popover dismissPopoverAnimated:YES];
}

-(void)addEvent:(id)sender {
    
    UIViewController *view = [[UIViewController alloc] init];
    [view.view setFrame:CGRectMake(0, 0, 200, 800)];
    
    //Create subviews for View Controller
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(popoverMargins, popoverMargins, popoverWidth-(popoverMargins*2), popoverElementHeight)];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight*2)+(popoverMargins*3)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight*3)+(popoverMargins*4)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    self.nameText = [[UITextField alloc] initWithFrame:CGRectMake(popoverMargins, ((popoverElementHeight)+(popoverMargins*2)), popoverWidth-(popoverMargins*2), popoverElementHeight)];
    
    //Insert Subviews to ViewController
    [view.view insertSubview:label atIndex:0];
    [view.view insertSubview:self.nameText atIndex:0];
    [view.view insertSubview:saveButton atIndex:1];
    [view.view insertSubview:cancelButton atIndex:1];
    
    //Customize Label
    label.text = @"Create a New Event";
    label.textAlignment = NSTextAlignmentCenter;
    
    //Customize Text Field
    self.nameText.backgroundColor = [UIColor whiteColor];
    self.nameText.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);

    //Customize Save Button
    [saveButton setTitle:@"Create Event" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(closePopoverFromSave) forControlEvents:UIControlEventTouchUpInside];
    VANTeamColor *color = [[VANTeamColor alloc] init];
    saveButton.backgroundColor = [color findTeamColor];
    
    //Customize Cancel Button
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeAndCancelPopover) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor lightGrayColor];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:view];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(popoverWidth, ([view.view.subviews count]*popoverElementHeight)+([view.view.subviews count]*popoverMargins)+popoverMargins);
    [self.popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width-50, 0, 50, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.nameText becomeFirstResponder];
}

-(void)completeNewEventCreationWithEvent:(Event *)event inDocument:(VANTryoutDocument *)document {
    [self performSegueWithIdentifier:@"pushToMain" sender:@[event, document]];
}

@end
