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
        FileStreamParser *parser = [[FileStreamParser alloc] initWithPath:path];
        
    }
    return 0;
}
