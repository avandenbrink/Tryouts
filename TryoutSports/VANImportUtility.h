//
//  VANImportUtility.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-22.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VANTryoutDocument;

@interface VANImportUtility : NSObject

+ (void)saveDocument:(VANTryoutDocument *)document;
+ (void)saveCustomURL:(NSURL *)url;
+ (NSString *)documentsDirectory;

+ (NSData *)securelyArchiveRootObject:(id)object;
+ (VANTryoutDocument *)securelyUnarchiveDocumentWithFile:(NSString *)filePath;



+ (VANTryoutDocument *)getLocalDocumentforName:(NSString *)name;
+ (NSArray *)getLocalFileList;


+ (NSArray *)nameVariations;
+ (NSArray *)numberVariations;
+ (NSArray *)emailVariations;
+ (NSArray *)phoneVariations;
+ (NSArray *)positionVariations;
+ (NSArray *)birthdateVariations;
@end
