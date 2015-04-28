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

@end

static const NSInteger maxBufLength = 512;

@implementation FileStreamParser

- (id)initWithPath:(NSString *)path {
    self = [super init];
    if (self)
    {
        [self setUpStreamForFile:path];
    }
    
    return self;
}

- (void)setUpStreamForFile:(NSString *)path
{
    iStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [iStream setDelegate:self];
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [iStream open];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
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
                NSLog(@"buffered string %@", stringToAnalyse);
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
            break;
        }
        default:
            break;
    }
}

- (void)setFilePath:(NSString *)filePath {
    
}

@end
