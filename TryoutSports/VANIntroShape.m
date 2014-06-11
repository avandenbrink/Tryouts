//
//  VANIntroShape.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-12.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroShape.h"
#import "VANTeamColor.h"
#import "Event.h"

static float const titleBarHeight = 25;
static float const teamBarHeight = 25;
static float const seenBarHeight = 20;

@interface VANIntroShape ()

@property (nonatomic, assign) CGFloat teamWidth;
@property (nonatomic, assign) CGFloat seenWidth;

@property (nonatomic, assign) CGFloat teamCount;
@property (nonatomic, assign) CGFloat seenCount;

@end

@implementation VANIntroShape

-(void)initiateWithEventInfo:(Event *)event {
    self.backgroundColor = [UIColor clearColor];
    
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];

    if (self.seenView == nil) {
        self.seenView = [[UIView alloc] initWithFrame:CGRectMake(0, titleBarHeight, 0, seenBarHeight)];
        self.seenView.backgroundColor = [teamColor washedColor];
        //self.seenView.layer.shadowOffset = CGSizeMake(0, 2);
        //self.seenView.layer.shadowOpacity = 0.2;
        [self.seenView setClipsToBounds:YES];
        
        self.seenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.seenWidth, teamBarHeight)];
        self.seenLabel.textColor = [UIColor whiteColor];
        self.seenLabel.textAlignment = NSTextAlignmentCenter;
        
        self.seenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.seenWidth, teamBarHeight+titleBarHeight)];

        [self.seenView addSubview:self.seenLabel];
        [self addSubview:self.seenView];
        [self addSubview:self.seenButton];
    }
    if (self.teamView == nil) {
        self.teamView = [[UIView alloc] initWithFrame:CGRectMake(0, titleBarHeight, 0, teamBarHeight)];
        self.teamView.backgroundColor = [teamColor findTeamColor];
        //self.teamView.layer.shadowOpacity = 0.2;
        //self.teamView.layer.shadowOffset = CGSizeMake(0, 2);
        
        self.teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.teamWidth, teamBarHeight)];
        self.teamLabel.textColor = [UIColor whiteColor];
        self.teamLabel.textAlignment = NSTextAlignmentCenter;

        self.teamButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.teamWidth, teamBarHeight+titleBarHeight)];
        
        [self.teamView addSubview:self.teamLabel];
        [self insertSubview:self.teamView belowSubview:self.seenButton];
        [self addSubview:self.teamButton];
    }
    if (self.barView == nil) {
        self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, titleBarHeight)];
        self.barView.translatesAutoresizingMaskIntoConstraints = NO;

        self.barView.backgroundColor = [UIColor blackColor];
        self.barView.layer.shadowOffset = CGSizeMake(0, 4);
        self.barView.layer.shadowOpacity = 0.3;
        
        self.statTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleBarHeight)];
        self.statTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.statTitle.textColor = [UIColor whiteColor];
        self.statTitle.textAlignment = NSTextAlignmentCenter;
        [self.barView addSubview:self.statTitle];
        self.statTitle.text = [NSString stringWithFormat:@"Total Athletes: %lu", (unsigned long)[event.athletes count]];

        
        [self insertSubview:self.barView aboveSubview:self.teamView];
        
        NSDictionary *dic = @{@"bar": self.barView,@"label":self.statTitle};
        NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[bar(%f)]",titleBarHeight] options:0 metrics:0 views:dic];
        [self addConstraints:constraint];
        
        constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]|" options:0 metrics:0 views:dic];
        [self addConstraints:constraint];
        
        constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:0 views:dic];
        [self.barView addConstraints:constraint];
        
        constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:0 views:dic];
        [self.barView addConstraints:constraint];
    }
    //[self findPercentAndAnimateChangesForEvent:event];
}

-(void)findPercentAndAnimateChangesForEvent:(Event*)event {
    
    if ([event.athletes count] > 0) {
        NSMutableArray *athletes = [self fetchTeamAthleteforEvent:event];
        NSMutableArray *seen = [self fetchSeenAthleteforEvent:event];
        
        //Temporary Example Floats till Fetch Requests are figured out
        CGFloat numOfAthletes = [event.athletes count];
        self.teamCount = [athletes count];
        self.seenCount = [seen count];
        
        CGFloat screenWidth = self.frame.size.width;
        
        self.teamWidth = self.teamCount / numOfAthletes * screenWidth;
        
        CGFloat pixForSeen = self.seenCount / numOfAthletes * screenWidth;
        self.seenWidth = pixForSeen;
        
        
        if (self.teamView.frame.size.width != self.teamWidth || self.seenView.frame.size.width != self.seenWidth) {
            self.statTitle.text = [NSString stringWithFormat:@"Total Athletes: %lu", (unsigned long)[event.athletes count]];

            [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                [self.teamView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth, teamBarHeight)];
                [self.teamLabel setFrame:CGRectMake(0, 0, self.teamWidth, teamBarHeight)];
                [self.teamButton setFrame:CGRectMake(0, 0, self.teamWidth, teamBarHeight+titleBarHeight)];
                
                [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.seenWidth, seenBarHeight)];
                [self.seenLabel setFrame:CGRectMake(self.teamWidth, 0, self.seenWidth-self.teamWidth, seenBarHeight)];
                [self.seenButton setFrame:CGRectMake(self.teamWidth, 0, self.seenWidth-self.teamWidth, seenBarHeight+titleBarHeight)];

                if (self.teamWidth < self.frame.size.width/2+self.frame.size.width/4) {
                    self.teamLabel.text = [NSString stringWithFormat:@"%.0f%%",self.teamCount/numOfAthletes*100];

                } else {
                    self.teamLabel.text = [NSString stringWithFormat:@"%.0f%% of Athletes on Team(s)",self.teamCount/numOfAthletes*100];
                }
                if (self.seenWidth-self.teamWidth < (self.frame.size.width/5)*3) {
                    self.seenLabel.text = [NSString stringWithFormat:@"%.0f%%",self.seenCount/numOfAthletes*100];
                } else {
                    self.seenLabel.text = [NSString stringWithFormat:@"%.0f%% of Athletes Seen", self.seenCount/numOfAthletes*100];
                }
                [self.seenButton addTarget:self action:@selector(expandSeen) forControlEvents:UIControlEventTouchUpInside];
                [self.teamButton addTarget:self action:@selector(expandTeam) forControlEvents:UIControlEventTouchUpInside];

            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

                }completion:^(BOOL finished){
                }];
            }];
        }
    } else {
        
    }
}

-(void)expandSeen {
    NSString *previousText = self.seenLabel.text;
    
    //Remove Target so that it can't be activated again
    [self.teamButton removeTarget:self action:@selector(expandTeam) forControlEvents:UIControlEventTouchUpInside];
    [self.seenButton removeTarget:self action:@selector(expandSeen) forControlEvents:UIControlEventTouchUpInside];

    //Start Animation
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (self.seenWidth-self.teamWidth < (self.frame.size.width/5)*3) {
            if (self.teamWidth < (self.frame.size.width/5)*2) {
                [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth+(self.frame.size.width/5)*3, seenBarHeight)];
                [self.seenLabel setFrame:CGRectMake(self.teamWidth, 0, (self.frame.size.width/5)*3,seenBarHeight)];
                
            } else {
                CGFloat size = (self.frame.size.width/5)*3 - (self.seenWidth-self.teamWidth);
                if (self.frame.size.width-self.seenWidth < size/2) {
                    [self.teamView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth-size, teamBarHeight)];
                    [self.teamLabel setCenter:CGPointMake((self.teamWidth-size)/2, teamBarHeight/2)];
                    [self.seenLabel setFrame:CGRectMake(self.teamWidth-size, 0, (self.frame.size.width/5)*3, seenBarHeight)];
                    [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.seenWidth, seenBarHeight)];
                } else {
                    [self.teamView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth-size/2, teamBarHeight)];
                    [self.teamLabel setCenter:CGPointMake((self.teamWidth-size/2)/2, teamBarHeight/2)];
                    [self.seenLabel setFrame:CGRectMake(self.teamWidth-size/2, 0, (self.frame.size.width/5)*3, seenBarHeight)];
                    [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.seenWidth+size/2, seenBarHeight)];
                }
            }
        }
        self.seenLabel.alpha = 0.0f;
        self.seenLabel.text = [NSString stringWithFormat:@"Athletes Seen: %.0f", self.seenCount];
        self.seenLabel.alpha = 1.0f;
        //Move team elements into place

        //    [self.seenLabel setFrame:CGRectMake(rect.size.width, 0, 50, seenBarHeight)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.teamView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth, teamBarHeight)];
            [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.seenWidth, seenBarHeight)];
            [self.teamLabel setCenter:CGPointMake(self.teamWidth/2, teamBarHeight/2)];
          //  [self.seenLabel setCenter:CGPointMake((self.seenWidth-self.teamWidth)/2+self.teamWidth, seenBarHeight/2)];
            self.seenLabel.alpha = 0.0f;
            
        } completion:^(BOOL done) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.seenLabel setFrame:CGRectMake(self.teamWidth, 0, self.seenWidth-self.teamWidth, seenBarHeight)];
                self.seenLabel.alpha = 1.0f;
                self.seenLabel.text = previousText;
            }completion:Nil];
            
            [self.teamButton addTarget:self action:@selector(expandTeam) forControlEvents:UIControlEventTouchUpInside];
            [self.seenButton addTarget:self action:@selector(expandSeen) forControlEvents:UIControlEventTouchUpInside];

        }];
    }];

}

-(void)expandTeam {
    NSString *previousText = self.teamLabel.text;
    CGPoint point = self.seenLabel.center;
    
    //Remove Target so that it can't be activated again
    [self.teamButton removeTarget:self action:@selector(expandTeam) forControlEvents:UIControlEventTouchUpInside];
    [self.seenButton removeTarget:self action:@selector(expandSeen) forControlEvents:UIControlEventTouchUpInside];

    //Start Animation
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //Move team elements into place
        CGRect rect = CGRectMake(0, titleBarHeight, (self.frame.size.width/4)*3, teamBarHeight);

        if (self.teamView.frame.size.width < rect.size.width) {

            [self.teamView setFrame:rect];
            [self.teamLabel setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];

        }
        self.teamLabel.alpha = 0.0f;
        self.teamLabel.text = [NSString stringWithFormat:@"Athletes on a Team: %.0f", self.teamCount];
        self.teamLabel.alpha = 1.0f;
        
        //Adjust Seen elements, if neccessary
        if (self.seenView.frame.size.width < rect.size.width+50) {
            [self.seenView setFrame:CGRectMake(0, titleBarHeight, rect.size.width + 50, seenBarHeight)];
            [self.seenLabel setCenter:CGPointMake(rect.size.width+25, seenBarHeight/2)];
        } else {
            [self.seenLabel setCenter:CGPointMake(rect.size.width+(self.seenView.frame.size.width-self.teamView.frame.size.width)/2, seenBarHeight/2)];
        }
    //    [self.seenLabel setFrame:CGRectMake(rect.size.width, 0, 50, seenBarHeight)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.teamView setFrame:CGRectMake(0, titleBarHeight, self.teamWidth, teamBarHeight)];
            [self.seenView setFrame:CGRectMake(0, titleBarHeight, self.seenWidth, seenBarHeight)];
            [self.seenLabel setCenter:point];
            self.teamLabel.alpha = 0.0f;
            
            
            // Add transition (must be called after myLabel has been displayed)
 //           CATransition *animation = [CATransition animation];
 //           animation.duration = 1.0;
 //           animation.type = kCATransitionFade;
 //           animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 //           [myLabel.layer addAnimation:animation forKey:@"changeTextTransition"];self.teamLabel.alpha = 1.0f;
        } completion:^(BOOL done) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.teamLabel setFrame:CGRectMake(0, 0, self.teamWidth, teamBarHeight)];
                self.teamLabel.alpha = 1.0f;
                self.teamLabel.text = previousText;
            }completion:Nil];
            
            [self.teamButton addTarget:self action:@selector(expandTeam) forControlEvents:UIControlEventTouchUpInside];
            [self.seenButton addTarget:self action:@selector(expandSeen) forControlEvents:UIControlEventTouchUpInside];

        }];
    }];
}

-(NSMutableArray *)fetchTeamAthleteforEvent:(Event *)event {
    NSManagedObjectContext *context = [event managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Athlete"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(self.event == %@) AND (self.teamSelected > 0)", event];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSMutableArray *array = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    if (array != nil) {
        //
        return array;
    }
    else {
        // Deal with error.
        NSLog(@"Failed to Return Athletes");
        return nil;
    }
}

-(NSMutableArray *)fetchSeenAthleteforEvent:(Event *)event {
    NSManagedObjectContext *context = [event managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Athlete"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(self.event == %@) AND (self.seen == 1)", event];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSMutableArray *array = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    if (array != nil) {
        //
        return array;
    }
    else {
        // Deal with error.
        NSLog(@"Failed to Return Athletes");
        return nil;
    }
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
}
/*
- (void)drawRect:(CGRect)rect
{
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    // Drawing code
    
    UIBezierPath *descriptionLine = [UIBezierPath bezierPath];
    [descriptionLine moveToPoint:CGPointMake(0, 0)];
    [descriptionLine addLineToPoint:CGPointMake(320, 0)];
    [descriptionLine addLineToPoint:CGPointMake(320, titleBarHeight)];
    [descriptionLine addLineToPoint:CGPointMake(0, titleBarHeight)];
    [descriptionLine closePath];
    
    //These lines of code take the path and move it to its designated description
    //CGContextRef curveRef = UIGraphicsGetCurrentContext();
    //CGContextTranslateCTM(curveRef, 0, self.frame.size.height-40);
    
    [[UIColor blackColor] setFill];
    [descriptionLine fill];
    
    if ( self.firstPoint.x > 0) {
        UIBezierPath *firstPath = [UIBezierPath bezierPath];
        [firstPath moveToPoint:CGPointMake(0, titleBarHeight)];
        [firstPath addLineToPoint:self.firstPoint];
        [firstPath addLineToPoint:CGPointMake(self.firstPoint.x, titleBarHeight+teamBarHeight)];
        NSLog(@"First Point: %f", self.firstPoint.x);
        [firstPath addLineToPoint:CGPointMake(0, titleBarHeight+teamBarHeight)];
        [firstPath closePath];
        
        [[teamColor findTeamColor] setFill];
        [firstPath fill];
    }
   
    if (self.secondPoint.x > self.firstPoint.x && self.secondPoint.x > 0) {
        UIBezierPath *secondPath = [UIBezierPath bezierPath];
        [secondPath moveToPoint:CGPointMake(0, titleBarHeight)];
        [secondPath addLineToPoint:self.secondPoint];
        [secondPath addLineToPoint:CGPointMake(self.secondPoint.x, titleBarHeight+seenBarHeight)];
        NSLog(@"Secont Point: %f", self.secondPoint.x);
        [secondPath addLineToPoint:CGPointMake(0, titleBarHeight+seenBarHeight)];
        [secondPath closePath];
        
        [[teamColor washedColor] setFill];
        [secondPath fill];
        
    }
    
    [self buildLabels];
    // Set the render colors.
    // If you have content to draw after the shape,
    // save the current state before changing the transform.
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, self.frame.size.width-100, self.frame.size.height -100);
    
    // Adjust the drawing options as needed.
   // aPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
    
}*/


@end
