//
//  main.m
//  FileProcessing
//
//  Created by Kirill Ushkov on 25.04.15.
//  Copyright (c) 2015 Kirill Ushkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStreamParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Vocabulary" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *path = [bundle pathForResource:@"file" ofType:@"txt"];

        dispatch_queue_t q = dispatch_queue_create("fileprocessingqueue", NULL);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            FileStreamParser *parser = [[FileStreamParser alloc] initWithPath:path
                                                          withProcessingBlock:^(NSString *string) {
                                                              NSLog(@"string %@", string);
                                                          }
                                                          withCompletionBlock:^{
                                                              NSLog(@"completion");
                                                              dispatch_semaphore_signal(semaphore);
                                                          }];

        });
        
        while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    return 0;
}
