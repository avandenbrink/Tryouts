//
//  VANConnectCentreController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANConnectCentreController.h"

@interface VANConnectCentreController ()

@end

@implementation VANConnectCentreController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendViaAirdrop:(id)sender {
}

- (IBAction)exportEvent:(id)sender {
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[self.document] applicationActivities:nil];
    activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityView animated:YES completion:nil];

    
//    
//    NSString *write = @"";
//    
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Event Name:, %@ \n", self.event.name]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Date:, %@ \n", [__dateFormatt stringFromDate:self.event.startDate]]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Location:, %@ \n", self.event.location]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Number of Teams:, %@ \n", self.event.numTeams]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Athlete Age:, %@ \n", self.event.athleteAge]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Athletes Per Team:, %@ \n", self.event.athletesPerTeam]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Number of Teams:, %@ \n", self.event.numTeams]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Positions:"]];
//    for (Positions *p in self.event.positions) {
//        write = [write stringByAppendingString:[NSString stringWithFormat:@",%@", p.position]];
//    }
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"\n"]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Skills:"]];
//    for (Skills *s in self.event.skills) {
//        write = [write stringByAppendingString:[NSString stringWithFormat:@",%@", s.descriptor]];
//    }
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"\n"]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Tests:"]];
//    for (Tests *t in self.event.tests) {
//        write = [write stringByAppendingString:[NSString stringWithFormat:@",%@", t.descriptor]];
//    }
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"\n"]];
//    write = [write stringByAppendingString:[NSString stringWithFormat:@"Number, Name, Birthday, Position, Email, Phone Number \n"]];
//
//    for (Athlete *a in self.event.athletes) {
//        write = [write stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@ \n", a.number, a.name, a.birthday, a.position, a.email, a.phoneNumber]];
//    }
//
//    NSLog(@"%@", write);
//    
//    NSString *newFile = [NSString stringWithFormat:@"/%@.csv",self.event.name];    
//    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *exportFilePath = [docDirectory stringByAppendingString:newFile];
//    
//    NSLog(@"%@", exportFilePath);
//    NSError *error;
//    if (![write writeToFile:exportFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
//        NSLog(@"Warning, Failed to write to path");
//    }
//    
//    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
//    controller.mailComposeDelegate = self;
//    
//    [controller setSubject:[NSString stringWithFormat:@"Tryout Sports Event: %@", self.event.name]];
//    
//    NSString *emailBody = [NSString stringWithFormat:@"This email contains the event data for %@ tryout. This file can be open as an excel document or can be imported to Tryout Sports on another device. \n \n Thank You for using Tryout Sports. \n We Hope that we have made your Tryout experience easier. \n  \n Tryout Sports is made by coaches, for coaches. If you have any suggestions or feedback, to help us improve your next time please let us know. \n ", self.event.name];
//    [controller setMessageBody:emailBody isHTML:NO];
//    
//    //Need to figure out how to build .csv file then use:
//    [controller addAttachmentData:[NSData dataWithContentsOfFile:exportFilePath] mimeType:@"text/cvs" fileName:newFile];
//    
//    [self presentViewController:controller animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
