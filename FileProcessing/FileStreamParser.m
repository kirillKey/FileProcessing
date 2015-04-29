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

static const NSInteger maxLength = 12;

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
        
        
        
        [result addObject:string];
    }
    
    NSLog(@"%@", result);
}



- (BOOL)stringContainsUppercaseString:(NSString*)string
{
    NSCharacterSet *set = [NSCharacterSet uppercaseLetterCharacterSet];
    
    return [string rangeOfCharacterFromSet:set].location != NSNotFound;
}

@end
