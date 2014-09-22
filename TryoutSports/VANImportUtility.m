 //
//  VANImportUtility.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-22.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANImportUtility.h"
#import "VANTryoutDocument.h"

NSString * const kProfileCustomFileExtension = @"customprofile";
NSString * const kProfileFilesFolderName = @"ProfileFiles";
NSString * const kCustomURLFile = @"customURL";
NSString * const kProfileArchiveKey = @"ProfileArchiveKey";
NSString * const kFileNameType = @".tryoutsports";

@implementation VANImportUtility


+ (void)saveDocument:(VANTryoutDocument *)document {
    
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSArray *filesComponents = [[document.fileURL absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName;
    if ([[filesComponents lastObject] isEqualToString:@""]) {
        fileName = [filesComponents objectAtIndex:[filesComponents count]-2];
    } else {
        fileName = [filesComponents lastObject];
    }
    NSURL *newURL = [url URLByAppendingPathComponent:fileName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:document.fileURL toURL:newURL error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+ (void)saveCustomURL:(NSURL *)url {
    
}

+ (NSString *)documentsDirectory {
    
    //Get path to the app's document directory
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return ([path count] > 0) ? [path objectAtIndex:0] : nil;
}

+ (NSString *)profilesFolderPath
{
    NSString *doucumentFolder = [VANImportUtility documentsDirectory];
    doucumentFolder = [doucumentFolder stringByAppendingPathComponent:kProfileFilesFolderName];
    
    //Create directory to store files if it does not already exist
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:doucumentFolder isDirectory:&isDir];
    
    if (!exists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:doucumentFolder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return doucumentFolder;
}

+ (NSData *)securelyArchiveRootObject:(id)object
{
    //Use secure encoding because files could be transfered from anywhere by anyone
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //Ensure that secure encoding is used
    [archiver setRequiresSecureCoding:YES];
    [archiver encodeObject:object forKey:kProfileArchiveKey];
    [archiver finishEncoding];
    
    return data;
}

+ (void)securelyArchiveRootObject:(id)object toFile:(NSString *)filePath
{
    NSData * data = [VANImportUtility securelyArchiveRootObject:object];
    [data writeToFile:filePath atomically:YES];
}

+ (VANTryoutDocument *)securelyUnarchiveDocumentWithFile:(NSString *)filePath
{
    //Use secure encoding because files could be transfered from anywhere by anyone
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:fileData];
    
    //Ensure that secure encoding is used
    [unarchiver setRequiresSecureCoding:YES];
    
    VANTryoutDocument *document = nil;
    
    @try {
        document= [unarchiver decodeObjectOfClass:[VANTryoutDocument class] forKey:kProfileArchiveKey];
    }
    @catch (NSException *exception) {
        if ([[exception name] isEqualToString:NSInvalidArchiveOperationException]) {
            NSLog(@"%@ failed to unarchive VANTryoutDocument: %@", NSStringFromSelector(_cmd), exception);
        }
        else
        {
            [exception raise];
        }
    }

    return document;
}

+ (VANTryoutDocument *)getLocalDocumentforName:(NSString *)name
{
    NSURL *docs = [NSURL URLWithString:[VANImportUtility documentsDirectory]];
    NSArray *allDocs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docs includingPropertiesForKeys:nil options:0 error:nil];
    NSString *fileName = [NSString stringWithFormat:@"%@%@", name, kFileNameType];
    NSURL *file;
    for (NSURL *url in allDocs) {
        if ([url.lastPathComponent isEqualToString:fileName]) {
            file = url;
            break;
        }
    }
    VANTryoutDocument *document = [[VANTryoutDocument alloc] initWithFileURL:file];
    return document;
}

+ (NSArray *)getLocalFileList
{
    NSURL *docs = [NSURL URLWithString:[VANImportUtility documentsDirectory]];
    NSArray* allContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docs includingPropertiesForKeys:nil options:0 error:nil];
    
    NSMutableArray *contents = [NSMutableArray array];
    for (NSURL *URLname in allContents) {
        NSString *name = [URLname absoluteString];
        if ([name rangeOfString:kFileNameType].location != NSNotFound) {
            NSURL *url = [URLname URLByResolvingSymlinksInPath];
            [contents addObject:url];
        }
    }
    NSMutableArray *fileList = [NSMutableArray array];
    
    for (NSURL* url in contents) {
        
        NSString* fileName = [url lastPathComponent];
        NSString* presentedName = [fileName stringByReplacingCharactersInRange:[fileName rangeOfString:kFileNameType] withString:@""];
        [fileList addObject:presentedName];
    }
    
    return fileList;
}

+ (NSArray *)singleNameVariations {
    return @[@"name", @"names", @"first name", @"first_name", @"givenname"];
}

+ (NSArray *)numberVariations {
    return @[@"number", @"#", @"numbers"];
}

+ (NSArray *)emailVariations {
    return @[@"email",@"emails"];
}

+ (NSArray *)phoneVariations {
    return @[@"phone",@"phone number", @"home", @"homephone", @"home phone", @"cell", @"cellphone", @"cell phone"];
}

+ (NSArray *)lastNameVariations {
    return @[@"last name", @"last names", @"last_name", @"surname"];
}

+ (NSArray *)positionVariations {
    return @[@"position", @"place", @"location"];
}

+(NSArray *)birthdateVariations {
    return @[@"birthday", @"year", @"birthdate", @"age"];
}
@end