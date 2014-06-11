//
//  VANEditConfig.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-27.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANEditSkillController.h"

@interface VANEditConfig : NSObject

@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (nonatomic) NSInteger optionIndex;
@property (nonatomic, weak) VANEditSkillController *delegate;

- (id)initWithResource:(NSString *)resource;
- (void)configureMutableArrayForKey:(NSString *)string;
- (NSString *)dataFilePathforPath:(NSString *)string;
-(NSMutableArray *)getPlistFileForResource:(NSString *)resource;
-(NSInteger)numberofRowsinSectionForResource:(NSString *)resource;
-(void)saveFileForFilePath:(NSString *)path;
- (BOOL)searchPlistArray:(NSMutableArray *)array forItem:(NSString *)string;
- (BOOL)shouldAddCellAccessoryforString:(NSString *)string;

@end
