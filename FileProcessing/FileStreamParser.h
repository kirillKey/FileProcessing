//
//  FileStreamParser.h
//  FileProcessing
//
//  Created by Kirill Ushkov on 28.04.15.
//  Copyright (c) 2015 Kirill Ushkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StringProcessingBlock)(NSString* string);
typedef void(^CompletionBlock)();

@interface FileStreamParser : NSObject
@property (nonatomic, strong) NSString *filePath;
- (id)initWithPath:(NSString*)path withProcessingBlock:(StringProcessingBlock)processingBlock
withCompletionBlock:(CompletionBlock) completionBlock;

@end
