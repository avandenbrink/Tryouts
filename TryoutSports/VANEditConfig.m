//
//  VANEditConfig.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-27.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANEditConfig.h"
#import "VANEditSkillController.h"

@interface VANEditConfig ()



@end

@implementation VANEditConfig

-(id)initWithResource:(NSString *)resource {
    self = [super init];
    if (self) {
        NSString *filePath = [self dataFilePathforPath:resource];
        NSString *dataPath = [NSString stringWithFormat:@"%@.plist", filePath];
        self.optionsArray = [NSMutableArray arrayWithContentsOfFile:dataPath];
    }
    return self;
}

-(void)configureMutableArrayForKey:(NSString *)string {

}

- (NSString *)dataFilePathforPath:(NSString *)string {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:string];
}

-(NSMutableArray *)getPlistFileForResource:(NSString *)resource {
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", resource];
    NSString *filePath = [self dataFilePathforPath:dataPath];
    //NSLog(@"File Path: %@", filePath);
    if ([NSMutableArray arrayWithContentsOfFile:filePath] != nil) {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
    } else {
        return [[NSMutableArray alloc] init];
    }
}

-(void)saveFileForFilePath:(NSString *)path {
    NSString *dataPath = [NSString stringWithFormat:@"%@.plist", path];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:dataPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"It Doesn't Exists");
    }
    if ([self.optionsArray writeToFile:plistPath atomically:YES]) // it will return bool value
        {  }
    else { NSLog(@"Failed to write"); }
    
}

-(NSInteger)numberofRowsinSectionForResource:(NSString *)resource {
    return [[self getPlistFileForResource:resource] count];
}

- (BOOL)searchPlistArray:(NSMutableArray *)array forItem:(NSString *)string {
    for (NSInteger i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i] isEqualToString:string]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)shouldAddCellAccessoryforString:(NSString *)string {
    if (self.optionIndex == 0) {
        for (Positions *position in [self.delegate.event.positions allObjects]) {
            if ([position.position isEqualToString:string]) {
                return YES;
            }
        }
    } else if (self.optionIndex == 1) {
        for (Skills *skill in [self.delegate.event.skills allObjects]) {
            if ([skill.descriptor isEqualToString:string]) {
                return YES;
            }
        }
    } else {
        for (Tests *test in [self.delegate.event.tests allObjects]) {
            if ([test.descriptor isEqualToString:string]) {
                return YES;
            }
        }
    }
    return NO;
}


@end
