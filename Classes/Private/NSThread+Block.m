//
//  NSThread+Block.m
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "NSThread+Block.h"

@implementation NSThread (Block)

+ (void)performOnThread:(NSThread *)thread block:(void (^)())block
{
    thread = thread ?: [NSThread mainThread];
    [self performSelector:@selector(performBlock:) onThread:thread withObject:(id)block
            waitUntilDone:NO];
}

+ (void)performBlock:(void (^)())block
{
    block ? block() : nil;
}

@end
