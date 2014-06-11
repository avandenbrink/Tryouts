//
//  VANHeadShotController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-10-03.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANHeadShotController.h"
#import "VANHeadshotCell.h"
#import "Image.h"

@interface VANHeadShotController ()

@property (nonatomic, strong) NSArray *athleteHeadshots;

@end

@implementation VANHeadShotController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *array = [NSMutableArray array];
    NSArray *athletes = [self.event.athletes allObjects];
    for (Athlete *athlete in athletes) {
        NSArray *headshots = [athlete.images allObjects];
        if ([headshots count] > 0) {
            [array addObject:[headshots objectAtIndex:0]];
        }
    }
    NSLog(@"%lu",(unsigned long)[array count]);
    self.athleteHeadshots = [NSArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.athleteHeadshots count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VANHeadshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Image *headShot = [self.athleteHeadshots objectAtIndex:indexPath.row];
    NSData *imageData = headShot.headShot;
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;
    return cell;
}

#pragma mark - Collection View Delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
