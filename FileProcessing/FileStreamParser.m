//
//  FileStreamParser.m
//  FileProcessing
//
//  Created by Kirill Ushkov on 28.04.15.
//  Copyright (c) 2015 Kirill Ushkov. All rights reserved.
//

#import "FileStreamParser.h"

@interface FileStreamParser ()<NSStreamDelegate> {
    NSInputStream *iStream;
    NSMutableData *data;
    NSInteger bytesRead;
}

@property (nonatomic, strong) CompletionBlock completion;
@property (nonatomic, strong) StringProcessingBlock processingBlock;

@end

static const NSInteger maxBufLength = 512;

@implementation FileStreamParser

- (id)initWithPath:(NSString *)path withProcessingBlock:(StringProcessingBlock)processingBlock withCompletionBlock:(CompletionBlock)completionBlock
{
    self = [super init];
    if (self)
    {
        self.completion = completionBlock;
        self.processingBlock = processingBlock;

        [self setUpStreamForFile:path];
    }
    
    return self;
}

- (void)setUpStreamForFile:(NSString *)path
{
    iStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [iStream setDelegate:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [iStream open];
    });
}

#pragma mark - NSStreamdelegate - 

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasBytesAvailable:
        {
            if (!data) {
                data = [[NSMutableData alloc] init];
            }
            
            uint8_t buf[maxBufLength];
            
            NSInteger len = 0;
            len = [(NSInputStream*)aStream read:buf maxLength:maxBufLength];
            
            if (len) {
                [data appendBytes:buf length:len];
                bytesRead += len;
                
                NSString *stringToAnalyse = [[NSString alloc] initWithData: data
                                                                  encoding: NSWindowsCP1251StringEncoding];
                if (self.processingBlock)
                {
                    self.processingBlock(stringToAnalyse);
                }
                
            } else {
                NSLog(@"no buffer");
            }
            break;
        }
            
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"Open completed");
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            NSLog(@"End of file encountered");
            
            [iStream close];
            [iStream removeFromRunLoop: [NSRunLoop currentRunLoop]
                               forMode: NSDefaultRunLoopMode];
            
            if (self.completion) {
                self.completion();
            }

            break;
        }
        default:
            break;
    }
}

- (void)setFilePath:(NSString *)filePath {
    
}

@end
