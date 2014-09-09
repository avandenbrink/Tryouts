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

@property (strong, nonatomic) VANTeamColor *teamColor;
- (BOOL)searchAthleteTagsForTag:(NSString *)string;

@end

@implementation VANCollectionCell

- (void)initiate
{
    _teamColor = [[VANTeamColor alloc] init];
    self.collectionView.allowsSelection = NO;
    UINib *nib = [UINib nibWithNibName:@"Tag" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"tag"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Collection View Data Source Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self.collectionView.collectionViewLayout invalidateLayout];
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger i = [self.athlete.aTags count];
    return i;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 7, 7, 7);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tag";
    VANTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 4.00f;
    cell.label.textColor = [UIColor whiteColor];
    
    AthleteTags *tag = [[self.athlete.aTags allObjects] objectAtIndex:indexPath.row];
    cell.label.text = tag.attribute;
    
    if (tag.type == [NSNumber numberWithInt:0]) {
        cell.backgroundColor = [_teamColor findTeamColor];
        if (cell.backgroundColor == [UIColor whiteColor]) {
            cell.label.textColor = [UIColor blackColor];
        }
    } else if (tag.type == [NSNumber numberWithInt:1]) {
        cell.backgroundColor = [_teamColor washedColor];
    } else {
        if ([_teamColor findTeamColor] == [UIColor whiteColor]) {
            cell.backgroundColor = [UIColor blackColor];
        } else {
            cell.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return cell;
}

#pragma mark - Collection View Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AthleteTags *tag = [[self.athlete.aTags allObjects] objectAtIndex:indexPath.row];
    CGSize textSize = [tag.attribute sizeWithAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:17]] forKeys:@[NSFontAttributeName]]];
  //  CGSize textSize = [tag.descriptor sizeWithFont:[UIFont systemFontOfSize:17]];
    return CGSizeMake(textSize.width + 24, textSize.height + 8);
}

#pragma mark - Custom Defined Methods

- (NSString *)dataFilePathforPath:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:string];
}

- (NSMutableArray *)getPlistFileForResource:(NSString *)resource
{
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", resource];
    NSString *filePath = [self dataFilePathforPath:dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"CharacteristicsDefault" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"Characteristics"]];
        return array;
    } else {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
    }
}

- (BOOL)searchAthleteTagsForTag:(NSString *)string
{
    for (NSInteger i = 0; i < [self.tagsArray count]; i++) {
        AthleteTags *tag = [self.tagsArray objectAtIndex:i];
        if ([tag.attribute isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

@end
