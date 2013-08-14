//
//  VANLeftAlignedFlowLayout.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-10.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANLeftAlignedFlowLayout.h"

@interface VANLeftAlignedFlowLayout ()

@property (nonatomic) UIEdgeInsets *itemInsets;
@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger rowWidth;
@property (nonatomic) NSInteger itemsInRow;
@property (nonatomic) NSArray *cellsDataStrings;

@end

const NSInteger kMaxCellSpacing = 4;

@implementation VANLeftAlignedFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
 
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    
    UIEdgeInsets sectionInset = self.sectionInset;
    
    if (indexPath.item == 0) { // first item of section
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + kMaxCellSpacing;
    
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentFrame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) { // if current item is the first item on the line
        // the approach here is to take the current frame, left align it to the edge of the view
        // then stretch it the width of the collection view, if it intersects with the previous frame then that means it
        // is on the same line, otherwise it is on it's own new line
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = frame.origin.x = sectionInset.left; // first item on the line should always be left aligned
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

/*
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
}
*/



@end
