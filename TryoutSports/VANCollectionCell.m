//
//  VANCollectionCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANCollectionCell.h"
#import "VANTagsCollectionCell.h"
#import "VANTeamColor.h"
#import "AthleteTags.h"

@interface VANCollectionCell ()

- (BOOL)searchAthleteTagsForTag:(NSString *)string;


@end

@implementation VANCollectionCell

- (id)init {
    self = [super init];
        // Initialization code
    
        //self.collectionView.contentSize = CGSizeMake(640, 100);
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsSelection = NO;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Collection View Data Source Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.athlete.aTags count];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(7, 7, 7, 7);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tag";
    VANTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    cell.layer.cornerRadius = 4.00f;
    
    cell.label.textColor = [UIColor whiteColor];
    AthleteTags *tag = [[self.athlete.aTags allObjects] objectAtIndex:indexPath.row];
    cell.label.text = tag.descriptor;
    if (tag.type == [NSNumber numberWithInt:0]) {
        cell.backgroundColor = [teamColor findTeamColor];
    } else if (tag.type == [NSNumber numberWithInt:1]) {
        cell.backgroundColor = [teamColor washedColor];
    } else {
        cell.backgroundColor = [UIColor darkGrayColor];
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    }
    return view;
}

#pragma mark - Collection View Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    AthleteTags *tag = [[self.athlete.aTags allObjects] objectAtIndex:indexPath.row];
    CGSize textSize = [tag.descriptor sizeWithAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:17]] forKeys:@[NSFontAttributeName]]];
  //  CGSize textSize = [tag.descriptor sizeWithFont:[UIFont systemFontOfSize:17]];
    return CGSizeMake(textSize.width + 24, textSize.height + 8);
}


#pragma mark - Custom Defined Methods

- (NSString *)dataFilePathforPath:(NSString *)string {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:string];
}

- (NSMutableArray *)getPlistFileForResource:(NSString *)resource {
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", resource];
    NSString *filePath = [self dataFilePathforPath:dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"CharacteristicsDefault" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"Characteristics"]];
//        NSLog(@"Returning default array");
        return array;
    } else {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
        NSLog(@"File Path: %@", filePath);
    }
}

- (BOOL)searchAthleteTagsForTag:(NSString *)string {
    for (NSInteger i = 0; i < [self.tagsArray count]; i++) {
        AthleteTags *tag = [self.tagsArray objectAtIndex:i];
        if ([tag.descriptor isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

@end
