//
//  FileStreamParser.m
//  FileProcessing
//
//  Created by Kirill Ushkov on 28.04.15.
//  Copyright (c) 2015 Kirill Ushkov. All rights reserved.
//

#import "FileStreamParser.h"

@interface FileStreamParser ()

@property (nonatomic, strong) CompletionBlock completion;
@property (nonatomic, strong) StringProcessingBlock processingBlock;
@property (nonatomic, strong) NSString *processedString;

@end

static const NSInteger maxLength = 10;

@implementation FileStreamParser

- (id)initWithPath:(NSString *)path withProcessingBlock:(StringProcessingBlock)processingBlock withCompletionBlock:(CompletionBlock)completionBlock
{
    self = [super init];
    if (self)
    {
        self.completion = completionBlock;
        self.processingBlock = processingBlock;

        self.processedString = [NSString stringWithContentsOfFile: path
                                                         encoding: NSWindowsCP1251StringEncoding
                                                            error: nil];
        [self processString];
    }
    
    return self;
}

- (void)processString {
    NSMutableArray *result = [NSMutableArray new];
    NSArray *strings = [self.processedString componentsSeparatedByString:@"\n"];
    for (NSString *string in strings) {
        if ([string containsString:@"ый"]) {
            continue;
        }
        
        else if ([string containsString:@"ий"]) {
            continue;
        }
        
        else if ([string containsString:@"ньк"]) {
            continue;
        }

        
        else if (string.length > maxLength) {
            continue;
        }
        else if ([self stringContainsUppercaseString:string]) {
            continue;
        }
        else if ([string containsString:@"нин"]) {
            continue;
        }
        else if ([string containsString:@"ть"]) {
            continue;
        }
        else if([string containsString:@"ой"]) {
            continue;
        }
        else if([self isString:string containingStringInTheEnd:@"но"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ее"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"то"]) {
            continue;
        }

        else if ([self isString:string containingStringInTheEnd:@"ски"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ин"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ое"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ие"]) {
            continue;
        }


        else if([self isString:string containingStringInTheEnd:@"ще"]) {
            continue;
        }

        else if([self isString:string containingStringInTheEnd:@"ит"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ид"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ент"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ез"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"изм"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"из"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ти"]) {
            continue;
        }

        else if([self isString:string containingStringInTheEnd:@"ат"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"о"]) {
            continue;
        }

        else if([self isString:string containingStringInTheEnd:@"че"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"же"]) {
            continue;
        }

        else if([self isString:string containingStringInTheEnd:@"ре"]) {
            continue;
        }
        
        else if([self isString:string containingStringInTheEnd:@"ше"]) {
            continue;
        }

        else if([self isString:string containingStringInTheEnd:@"ечь"]) {
            continue;
        }

        
        else if (![self isCorrectString:string]) {
            continue;
        }
        
        [result addObject:string];
    }
    
    NSString *documentPath = [documentDirectory() stringByAppendingString:@"/result.plist"];
    [result writeToFile:documentPath atomically:YES];
}

NSString* documentDirectory() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (BOOL)isString:(NSString*)string containingStringInTheEnd:(NSString*)searchString{
    NSRange range = [string rangeOfString:searchString];
    
    if (range.location == string.length-searchString.length-1) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isCorrectString:(NSString*)string {
    NSMutableCharacterSet *set = [NSCharacterSet punctuationCharacterSet].mutableCopy;
//    [set formIntersectionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [string rangeOfCharacterFromSet:set].location == NSNotFound;
}

- (BOOL)stringContainsUppercaseString:(NSString*)string
{
    NSCharacterSet *set = [NSCharacterSet uppercaseLetterCharacterSet];
    
    return [string rangeOfCharacterFromSet:set].location != NSNotFound;
}

@end
