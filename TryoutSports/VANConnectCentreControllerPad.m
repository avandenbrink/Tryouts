//
//  VANConnectCentreControllerPad.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-21.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANConnectCentreControllerPad.h"

@interface VANConnectCentreControllerPad ()

@property (strong, nonatomic) UIPopoverController *popOver;

@end

@implementation VANConnectCentreControllerPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendViaAirdrop:(id)sender {
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"Testing",self.document] applicationActivities:nil];
    activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    
    self.popOver = [[UIPopoverController alloc] initWithContentViewController:activityView];
    [self.popOver presentPopoverFromBarButtonItem:self.airdrop permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

@end
